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

abstract class ActivityCounts implements _i1.SerializableModel {
  ActivityCounts._({
    required this.openPullRequests,
    required this.openIssues,
    required this.unreadNotifications,
  });

  factory ActivityCounts({
    required int openPullRequests,
    required int openIssues,
    required int unreadNotifications,
  }) = _ActivityCountsImpl;

  factory ActivityCounts.fromJson(Map<String, dynamic> jsonSerialization) {
    return ActivityCounts(
      openPullRequests: jsonSerialization['openPullRequests'] as int,
      openIssues: jsonSerialization['openIssues'] as int,
      unreadNotifications: jsonSerialization['unreadNotifications'] as int,
    );
  }

  int openPullRequests;

  int openIssues;

  int unreadNotifications;

  /// Returns a shallow copy of this [ActivityCounts]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ActivityCounts copyWith({
    int? openPullRequests,
    int? openIssues,
    int? unreadNotifications,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ActivityCounts',
      'openPullRequests': openPullRequests,
      'openIssues': openIssues,
      'unreadNotifications': unreadNotifications,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ActivityCountsImpl extends ActivityCounts {
  _ActivityCountsImpl({
    required int openPullRequests,
    required int openIssues,
    required int unreadNotifications,
  }) : super._(
         openPullRequests: openPullRequests,
         openIssues: openIssues,
         unreadNotifications: unreadNotifications,
       );

  /// Returns a shallow copy of this [ActivityCounts]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ActivityCounts copyWith({
    int? openPullRequests,
    int? openIssues,
    int? unreadNotifications,
  }) {
    return ActivityCounts(
      openPullRequests: openPullRequests ?? this.openPullRequests,
      openIssues: openIssues ?? this.openIssues,
      unreadNotifications: unreadNotifications ?? this.unreadNotifications,
    );
  }
}
