import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

/// Service for interacting with the GitHub REST API.
/// Handles both authenticated (PAT) and anonymous requests with rate limiting.
class GitHubApiService {
  final String? pat;
  final http.Client _client;

  /// Rate limit tracking
  int remainingRequests;
  DateTime? rateLimitReset;

  /// Max pages to fetch per sync (MVP limit)
  static const int maxPagesPerSync = 2;

  /// Max items per page
  static const int perPage = 50;

  GitHubApiService({this.pat, http.Client? client})
      : _client = client ?? http.Client(),
        remainingRequests = pat != null ? 5000 : 60;

  /// Headers for API requests
  Map<String, String> get _headers {
    final headers = {
      'Accept': 'application/vnd.github+json',
      'X-GitHub-Api-Version': '2022-11-28',
    };
    if (pat != null) {
      headers['Authorization'] = 'Bearer $pat';
    }
    return headers;
  }

  /// Make an HTTP GET request with rate limit handling.
  Future<http.Response> _makeRequest(Uri uri, {int retryCount = 0}) async {
    final response = await _client.get(uri, headers: _headers);

    // Parse rate limit headers
    final remaining = response.headers['x-ratelimit-remaining'];
    if (remaining != null) {
      remainingRequests = int.tryParse(remaining) ?? remainingRequests;
    }

    final resetTimestamp = response.headers['x-ratelimit-reset'];
    if (resetTimestamp != null) {
      final timestamp = int.tryParse(resetTimestamp);
      if (timestamp != null) {
        rateLimitReset = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      }
    }

    // Handle rate limiting with exponential backoff
    if (response.statusCode == 403 || response.statusCode == 429) {
      if (retryCount >= 3) {
        throw GitHubApiException(
          'Rate limit exceeded after $retryCount retries',
          statusCode: response.statusCode,
        );
      }
      await _waitForRateLimit(retryCount);
      return _makeRequest(uri, retryCount: retryCount + 1);
    }

    return response;
  }

  /// Wait for rate limit with exponential backoff.
  Future<void> _waitForRateLimit(int retryCount) async {
    if (rateLimitReset != null) {
      final waitTime = rateLimitReset!.difference(DateTime.now());
      if (!waitTime.isNegative) {
        // Wait until reset time plus a small buffer
        await Future.delayed(waitTime + const Duration(seconds: 1));
        return;
      }
    }

    // Exponential backoff: 1s, 2s, 4s...
    final backoffSeconds = pow(2, retryCount).toInt();
    await Future.delayed(Duration(seconds: backoffSeconds));
  }

  /// Check if we have remaining requests.
  bool get hasRemainingRequests => remainingRequests > 0;

  /// Get authenticated user information.
  Future<Map<String, dynamic>> getUser() async {
    if (pat == null) {
      throw GitHubApiException('PAT required to get user info');
    }

    final uri = Uri.parse('https://api.github.com/user');
    final response = await _makeRequest(uri);

    if (response.statusCode != 200) {
      throw GitHubApiException(
        'Failed to get user: ${response.body}',
        statusCode: response.statusCode,
      );
    }

    return json.decode(response.body) as Map<String, dynamic>;
  }

  /// Get repository information.
  Future<Map<String, dynamic>> getRepository(String owner, String repo) async {
    final uri = Uri.parse('https://api.github.com/repos/$owner/$repo');
    final response = await _makeRequest(uri);

    if (response.statusCode == 404) {
      throw GitHubApiException(
        'Repository not found: $owner/$repo',
        statusCode: 404,
      );
    }

    if (response.statusCode != 200) {
      throw GitHubApiException(
        'Failed to get repository: ${response.body}',
        statusCode: response.statusCode,
      );
    }

    return json.decode(response.body) as Map<String, dynamic>;
  }

  /// Get pull requests for a repository.
  /// Returns PRs sorted by updated date (most recent first).
  /// Fetches up to [maxPagesPerSync] pages.
  Future<List<Map<String, dynamic>>> getPullRequests(
    String owner,
    String repo, {
    DateTime? since,
    int maxPages = maxPagesPerSync,
  }) async {
    final results = <Map<String, dynamic>>[];

    for (var page = 1; page <= maxPages; page++) {
      final queryParams = {
        'state': 'all',
        'sort': 'updated',
        'direction': 'desc',
        'per_page': perPage.toString(),
        'page': page.toString(),
      };

      final uri = Uri.https(
        'api.github.com',
        '/repos/$owner/$repo/pulls',
        queryParams,
      );

      final response = await _makeRequest(uri);

      if (response.statusCode != 200) {
        throw GitHubApiException(
          'Failed to get pull requests: ${response.body}',
          statusCode: response.statusCode,
        );
      }

      final prs = (json.decode(response.body) as List).cast<Map<String, dynamic>>();

      // Filter by since date if provided
      if (since != null) {
        final filtered = prs.where((pr) {
          final updatedAt = DateTime.parse(pr['updated_at'] as String);
          return updatedAt.isAfter(since);
        }).toList();

        results.addAll(filtered);

        // If we got fewer filtered results than the page size,
        // we've gone past the since date - stop paginating
        if (filtered.length < prs.length) {
          break;
        }
      } else {
        results.addAll(prs);
      }

      // If we got fewer results than requested, no more pages
      if (prs.length < perPage) {
        break;
      }

      // Respect rate limits between pages
      if (!hasRemainingRequests) {
        break;
      }
    }

    return results;
  }

  /// Get issues for a repository.
  /// Returns issues sorted by updated date (most recent first).
  /// Fetches up to [maxPagesPerSync] pages.
  /// Note: GitHub API returns PRs in issues endpoint, we filter them out.
  Future<List<Map<String, dynamic>>> getIssues(
    String owner,
    String repo, {
    DateTime? since,
    int maxPages = maxPagesPerSync,
  }) async {
    final results = <Map<String, dynamic>>[];

    for (var page = 1; page <= maxPages; page++) {
      final queryParams = {
        'state': 'all',
        'sort': 'updated',
        'direction': 'desc',
        'per_page': perPage.toString(),
        'page': page.toString(),
      };

      if (since != null) {
        queryParams['since'] = since.toUtc().toIso8601String();
      }

      final uri = Uri.https(
        'api.github.com',
        '/repos/$owner/$repo/issues',
        queryParams,
      );

      final response = await _makeRequest(uri);

      if (response.statusCode != 200) {
        throw GitHubApiException(
          'Failed to get issues: ${response.body}',
          statusCode: response.statusCode,
        );
      }

      final items = (json.decode(response.body) as List).cast<Map<String, dynamic>>();

      // Filter out pull requests (they have a 'pull_request' key)
      final issues = items.where((item) => !item.containsKey('pull_request')).toList();

      results.addAll(issues);

      // If we got fewer results than requested, no more pages
      if (items.length < perPage) {
        break;
      }

      // Respect rate limits between pages
      if (!hasRemainingRequests) {
        break;
      }
    }

    return results;
  }

  /// Dispose of the HTTP client.
  void dispose() {
    _client.close();
  }
}

/// Exception for GitHub API errors.
class GitHubApiException implements Exception {
  final String message;
  final int? statusCode;

  GitHubApiException(this.message, {this.statusCode});

  @override
  String toString() => 'GitHubApiException: $message (status: $statusCode)';
}
