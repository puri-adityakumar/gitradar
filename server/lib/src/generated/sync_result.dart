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
import 'package:serverpod/serverpod.dart' as _i1;

abstract class SyncResult
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  SyncResult._({
    required this.repositoryId,
    required this.newPullRequests,
    required this.updatedPullRequests,
    required this.newIssues,
    required this.updatedIssues,
    required this.notificationsCreated,
    required this.syncedAt,
  });

  factory SyncResult({
    required int repositoryId,
    required int newPullRequests,
    required int updatedPullRequests,
    required int newIssues,
    required int updatedIssues,
    required int notificationsCreated,
    required DateTime syncedAt,
  }) = _SyncResultImpl;

  factory SyncResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return SyncResult(
      repositoryId: jsonSerialization['repositoryId'] as int,
      newPullRequests: jsonSerialization['newPullRequests'] as int,
      updatedPullRequests: jsonSerialization['updatedPullRequests'] as int,
      newIssues: jsonSerialization['newIssues'] as int,
      updatedIssues: jsonSerialization['updatedIssues'] as int,
      notificationsCreated: jsonSerialization['notificationsCreated'] as int,
      syncedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['syncedAt'],
      ),
    );
  }

  int repositoryId;

  int newPullRequests;

  int updatedPullRequests;

  int newIssues;

  int updatedIssues;

  int notificationsCreated;

  DateTime syncedAt;

  /// Returns a shallow copy of this [SyncResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SyncResult copyWith({
    int? repositoryId,
    int? newPullRequests,
    int? updatedPullRequests,
    int? newIssues,
    int? updatedIssues,
    int? notificationsCreated,
    DateTime? syncedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SyncResult',
      'repositoryId': repositoryId,
      'newPullRequests': newPullRequests,
      'updatedPullRequests': updatedPullRequests,
      'newIssues': newIssues,
      'updatedIssues': updatedIssues,
      'notificationsCreated': notificationsCreated,
      'syncedAt': syncedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SyncResult',
      'repositoryId': repositoryId,
      'newPullRequests': newPullRequests,
      'updatedPullRequests': updatedPullRequests,
      'newIssues': newIssues,
      'updatedIssues': updatedIssues,
      'notificationsCreated': notificationsCreated,
      'syncedAt': syncedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _SyncResultImpl extends SyncResult {
  _SyncResultImpl({
    required int repositoryId,
    required int newPullRequests,
    required int updatedPullRequests,
    required int newIssues,
    required int updatedIssues,
    required int notificationsCreated,
    required DateTime syncedAt,
  }) : super._(
         repositoryId: repositoryId,
         newPullRequests: newPullRequests,
         updatedPullRequests: updatedPullRequests,
         newIssues: newIssues,
         updatedIssues: updatedIssues,
         notificationsCreated: notificationsCreated,
         syncedAt: syncedAt,
       );

  /// Returns a shallow copy of this [SyncResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SyncResult copyWith({
    int? repositoryId,
    int? newPullRequests,
    int? updatedPullRequests,
    int? newIssues,
    int? updatedIssues,
    int? notificationsCreated,
    DateTime? syncedAt,
  }) {
    return SyncResult(
      repositoryId: repositoryId ?? this.repositoryId,
      newPullRequests: newPullRequests ?? this.newPullRequests,
      updatedPullRequests: updatedPullRequests ?? this.updatedPullRequests,
      newIssues: newIssues ?? this.newIssues,
      updatedIssues: updatedIssues ?? this.updatedIssues,
      notificationsCreated: notificationsCreated ?? this.notificationsCreated,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }
}
