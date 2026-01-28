import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gitradar_client/gitradar_client.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme.dart';
import '../../shared/widgets/empty_widget.dart';
import '../../shared/widgets/error_widget.dart';
import '../../shared/widgets/loading_widget.dart';
import 'activity_provider.dart';

/// Activity screen with tabs for PRs and Issues.
class ActivityScreen extends ConsumerStatefulWidget {
  const ActivityScreen({super.key});

  @override
  ConsumerState<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends ConsumerState<ActivityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final countsAsync = ref.watch(activityCountsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.merge_type, size: 18),
                  const SizedBox(width: 8),
                  Text('PRs'),
                  countsAsync.whenData((counts) {
                    if (counts.openPullRequests > 0) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: _buildBadge(counts.openPullRequests),
                      );
                    }
                    return const SizedBox.shrink();
                  }).value ?? const SizedBox.shrink(),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.bug_report, size: 18),
                  const SizedBox(width: 8),
                  Text('Issues'),
                  countsAsync.whenData((counts) {
                    if (counts.openIssues > 0) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: _buildBadge(counts.openIssues),
                      );
                    }
                    return const SizedBox.shrink();
                  }).value ?? const SizedBox.shrink(),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _PullRequestsTab(),
          _IssuesTab(),
        ],
      ),
    );
  }

  Widget _buildBadge(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        count > 99 ? '99+' : count.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _PullRequestsTab extends ConsumerWidget {
  const _PullRequestsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prsAsync = ref.watch(pullRequestsProvider);

    return prsAsync.when(
      loading: () => const LoadingWidget(message: 'Loading pull requests...'),
      error: (error, stack) => ErrorDisplay(
        message: 'Failed to load pull requests:\n$error',
        onRetry: () => ref.invalidate(pullRequestsProvider),
      ),
      data: (result) {
        if (result.items.isEmpty) {
          return const EmptyWidget(
            icon: Icons.merge_type,
            title: 'No pull requests',
            subtitle: 'Pull requests from your tracked repositories will appear here.',
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(pullRequestsProvider);
            await ref.read(pullRequestsProvider.future);
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: result.items.length,
            itemBuilder: (context, index) => _PullRequestCard(pr: result.items[index]),
          ),
        );
      },
    );
  }
}

class _PullRequestCard extends ConsumerWidget {
  final PullRequest pr;

  const _PullRequestCard({required this.pr});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateColor = pr.state == 'open' ? AppTheme.prOpenColor : AppTheme.prClosedColor;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _openInGitHub(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.merge_type, size: 16, color: stateColor),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: stateColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      pr.state.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: stateColor,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '#${pr.number}',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                pr.title,
                style: TextStyle(
                  fontWeight: pr.isRead ? FontWeight.normal : FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    pr.author,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '•',
                    style: TextStyle(color: Colors.grey.shade400),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    timeago.format(pr.githubUpdatedAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openInGitHub(BuildContext context) async {
    final uri = Uri.parse(pr.htmlUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open link')),
      );
    }
  }
}

class _IssuesTab extends ConsumerWidget {
  const _IssuesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final issuesAsync = ref.watch(issuesProvider);

    return issuesAsync.when(
      loading: () => const LoadingWidget(message: 'Loading issues...'),
      error: (error, stack) => ErrorDisplay(
        message: 'Failed to load issues:\n$error',
        onRetry: () => ref.invalidate(issuesProvider),
      ),
      data: (result) {
        if (result.items.isEmpty) {
          return const EmptyWidget(
            icon: Icons.bug_report,
            title: 'No issues',
            subtitle: 'Issues from your tracked repositories will appear here.',
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(issuesProvider);
            await ref.read(issuesProvider.future);
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: result.items.length,
            itemBuilder: (context, index) => _IssueCard(issue: result.items[index]),
          ),
        );
      },
    );
  }
}

class _IssueCard extends ConsumerWidget {
  final Issue issue;

  const _IssueCard({required this.issue});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateColor = issue.state == 'open' ? AppTheme.issueOpenColor : AppTheme.issueClosedColor;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _openInGitHub(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.bug_report, size: 16, color: stateColor),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: stateColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      issue.state.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: stateColor,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '#${issue.number}',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                issue.title,
                style: TextStyle(
                  fontWeight: issue.isRead ? FontWeight.normal : FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    issue.author,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '•',
                    style: TextStyle(color: Colors.grey.shade400),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    timeago.format(issue.githubUpdatedAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openInGitHub(BuildContext context) async {
    final uri = Uri.parse(issue.htmlUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open link')),
      );
    }
  }
}
