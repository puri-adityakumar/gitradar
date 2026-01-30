/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'activity_counts.dart' as _i2;
import 'api_exception.dart' as _i3;
import 'auth_response.dart' as _i4;
import 'issue.dart' as _i5;
import 'issue_filter.dart' as _i6;
import 'notification.dart' as _i7;
import 'paginated_issues.dart' as _i8;
import 'paginated_notifications.dart' as _i9;
import 'paginated_pull_requests.dart' as _i10;
import 'pull_request.dart' as _i11;
import 'pull_request_filter.dart' as _i12;
import 'repository.dart' as _i13;
import 'sync_result.dart' as _i14;
import 'user.dart' as _i15;
import 'user_preferences.dart' as _i16;
import 'package:gitradar_client/src/protocol/repository.dart' as _i17;
import 'package:gitradar_client/src/protocol/sync_result.dart' as _i18;
export 'activity_counts.dart';
export 'api_exception.dart';
export 'auth_response.dart';
export 'issue.dart';
export 'issue_filter.dart';
export 'notification.dart';
export 'paginated_issues.dart';
export 'paginated_notifications.dart';
export 'paginated_pull_requests.dart';
export 'pull_request.dart';
export 'pull_request_filter.dart';
export 'repository.dart';
export 'sync_result.dart';
export 'user.dart';
export 'user_preferences.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2.ActivityCounts) {
      return _i2.ActivityCounts.fromJson(data) as T;
    }
    if (t == _i3.ApiException) {
      return _i3.ApiException.fromJson(data) as T;
    }
    if (t == _i4.AuthResponse) {
      return _i4.AuthResponse.fromJson(data) as T;
    }
    if (t == _i5.Issue) {
      return _i5.Issue.fromJson(data) as T;
    }
    if (t == _i6.IssueFilter) {
      return _i6.IssueFilter.fromJson(data) as T;
    }
    if (t == _i7.Notification) {
      return _i7.Notification.fromJson(data) as T;
    }
    if (t == _i8.PaginatedIssues) {
      return _i8.PaginatedIssues.fromJson(data) as T;
    }
    if (t == _i9.PaginatedNotifications) {
      return _i9.PaginatedNotifications.fromJson(data) as T;
    }
    if (t == _i10.PaginatedPullRequests) {
      return _i10.PaginatedPullRequests.fromJson(data) as T;
    }
    if (t == _i11.PullRequest) {
      return _i11.PullRequest.fromJson(data) as T;
    }
    if (t == _i12.PullRequestFilter) {
      return _i12.PullRequestFilter.fromJson(data) as T;
    }
    if (t == _i13.Repository) {
      return _i13.Repository.fromJson(data) as T;
    }
    if (t == _i14.SyncResult) {
      return _i14.SyncResult.fromJson(data) as T;
    }
    if (t == _i15.User) {
      return _i15.User.fromJson(data) as T;
    }
    if (t == _i16.UserPreferences) {
      return _i16.UserPreferences.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.ActivityCounts?>()) {
      return (data != null ? _i2.ActivityCounts.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.ApiException?>()) {
      return (data != null ? _i3.ApiException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.AuthResponse?>()) {
      return (data != null ? _i4.AuthResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.Issue?>()) {
      return (data != null ? _i5.Issue.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.IssueFilter?>()) {
      return (data != null ? _i6.IssueFilter.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.Notification?>()) {
      return (data != null ? _i7.Notification.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.PaginatedIssues?>()) {
      return (data != null ? _i8.PaginatedIssues.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.PaginatedNotifications?>()) {
      return (data != null ? _i9.PaginatedNotifications.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i10.PaginatedPullRequests?>()) {
      return (data != null ? _i10.PaginatedPullRequests.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i11.PullRequest?>()) {
      return (data != null ? _i11.PullRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.PullRequestFilter?>()) {
      return (data != null ? _i12.PullRequestFilter.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.Repository?>()) {
      return (data != null ? _i13.Repository.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.SyncResult?>()) {
      return (data != null ? _i14.SyncResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.User?>()) {
      return (data != null ? _i15.User.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.UserPreferences?>()) {
      return (data != null ? _i16.UserPreferences.fromJson(data) : null) as T;
    }
    if (t == List<_i5.Issue>) {
      return (data as List).map((e) => deserialize<_i5.Issue>(e)).toList() as T;
    }
    if (t == List<_i7.Notification>) {
      return (data as List)
              .map((e) => deserialize<_i7.Notification>(e))
              .toList()
          as T;
    }
    if (t == List<_i11.PullRequest>) {
      return (data as List)
              .map((e) => deserialize<_i11.PullRequest>(e))
              .toList()
          as T;
    }
    if (t == List<_i17.Repository>) {
      return (data as List).map((e) => deserialize<_i17.Repository>(e)).toList()
          as T;
    }
    if (t == Map<String, dynamic>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<dynamic>(v)),
          )
          as T;
    }
    if (t == List<_i18.SyncResult>) {
      return (data as List).map((e) => deserialize<_i18.SyncResult>(e)).toList()
          as T;
    }
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.ActivityCounts => 'ActivityCounts',
      _i3.ApiException => 'ApiException',
      _i4.AuthResponse => 'AuthResponse',
      _i5.Issue => 'Issue',
      _i6.IssueFilter => 'IssueFilter',
      _i7.Notification => 'Notification',
      _i8.PaginatedIssues => 'PaginatedIssues',
      _i9.PaginatedNotifications => 'PaginatedNotifications',
      _i10.PaginatedPullRequests => 'PaginatedPullRequests',
      _i11.PullRequest => 'PullRequest',
      _i12.PullRequestFilter => 'PullRequestFilter',
      _i13.Repository => 'Repository',
      _i14.SyncResult => 'SyncResult',
      _i15.User => 'User',
      _i16.UserPreferences => 'UserPreferences',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('gitradar.', '');
    }

    switch (data) {
      case _i2.ActivityCounts():
        return 'ActivityCounts';
      case _i3.ApiException():
        return 'ApiException';
      case _i4.AuthResponse():
        return 'AuthResponse';
      case _i5.Issue():
        return 'Issue';
      case _i6.IssueFilter():
        return 'IssueFilter';
      case _i7.Notification():
        return 'Notification';
      case _i8.PaginatedIssues():
        return 'PaginatedIssues';
      case _i9.PaginatedNotifications():
        return 'PaginatedNotifications';
      case _i10.PaginatedPullRequests():
        return 'PaginatedPullRequests';
      case _i11.PullRequest():
        return 'PullRequest';
      case _i12.PullRequestFilter():
        return 'PullRequestFilter';
      case _i13.Repository():
        return 'Repository';
      case _i14.SyncResult():
        return 'SyncResult';
      case _i15.User():
        return 'User';
      case _i16.UserPreferences():
        return 'UserPreferences';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'ActivityCounts') {
      return deserialize<_i2.ActivityCounts>(data['data']);
    }
    if (dataClassName == 'ApiException') {
      return deserialize<_i3.ApiException>(data['data']);
    }
    if (dataClassName == 'AuthResponse') {
      return deserialize<_i4.AuthResponse>(data['data']);
    }
    if (dataClassName == 'Issue') {
      return deserialize<_i5.Issue>(data['data']);
    }
    if (dataClassName == 'IssueFilter') {
      return deserialize<_i6.IssueFilter>(data['data']);
    }
    if (dataClassName == 'Notification') {
      return deserialize<_i7.Notification>(data['data']);
    }
    if (dataClassName == 'PaginatedIssues') {
      return deserialize<_i8.PaginatedIssues>(data['data']);
    }
    if (dataClassName == 'PaginatedNotifications') {
      return deserialize<_i9.PaginatedNotifications>(data['data']);
    }
    if (dataClassName == 'PaginatedPullRequests') {
      return deserialize<_i10.PaginatedPullRequests>(data['data']);
    }
    if (dataClassName == 'PullRequest') {
      return deserialize<_i11.PullRequest>(data['data']);
    }
    if (dataClassName == 'PullRequestFilter') {
      return deserialize<_i12.PullRequestFilter>(data['data']);
    }
    if (dataClassName == 'Repository') {
      return deserialize<_i13.Repository>(data['data']);
    }
    if (dataClassName == 'SyncResult') {
      return deserialize<_i14.SyncResult>(data['data']);
    }
    if (dataClassName == 'User') {
      return deserialize<_i15.User>(data['data']);
    }
    if (dataClassName == 'UserPreferences') {
      return deserialize<_i16.UserPreferences>(data['data']);
    }
    return super.deserializeByClassName(data);
  }

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
