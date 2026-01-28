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

abstract class Repository implements _i1.SerializableModel {
  Repository._({
    this.id,
    required this.userId,
    required this.owner,
    required this.repo,
    required this.githubRepoId,
    required this.isPrivate,
    required this.inAppNotifications,
    required this.pushNotifications,
    required this.notificationLevel,
    this.lastSyncedAt,
    this.lastPrCursor,
    this.lastIssueCursor,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Repository({
    int? id,
    required int userId,
    required String owner,
    required String repo,
    required int githubRepoId,
    required bool isPrivate,
    required bool inAppNotifications,
    required bool pushNotifications,
    required String notificationLevel,
    DateTime? lastSyncedAt,
    DateTime? lastPrCursor,
    DateTime? lastIssueCursor,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _RepositoryImpl;

  factory Repository.fromJson(Map<String, dynamic> jsonSerialization) {
    return Repository(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      owner: jsonSerialization['owner'] as String,
      repo: jsonSerialization['repo'] as String,
      githubRepoId: jsonSerialization['githubRepoId'] as int,
      isPrivate: jsonSerialization['isPrivate'] as bool,
      inAppNotifications: jsonSerialization['inAppNotifications'] as bool,
      pushNotifications: jsonSerialization['pushNotifications'] as bool,
      notificationLevel: jsonSerialization['notificationLevel'] as String,
      lastSyncedAt: jsonSerialization['lastSyncedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastSyncedAt'],
            ),
      lastPrCursor: jsonSerialization['lastPrCursor'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastPrCursor'],
            ),
      lastIssueCursor: jsonSerialization['lastIssueCursor'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastIssueCursor'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userId;

  String owner;

  String repo;

  int githubRepoId;

  bool isPrivate;

  bool inAppNotifications;

  bool pushNotifications;

  String notificationLevel;

  DateTime? lastSyncedAt;

  DateTime? lastPrCursor;

  DateTime? lastIssueCursor;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [Repository]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Repository copyWith({
    int? id,
    int? userId,
    String? owner,
    String? repo,
    int? githubRepoId,
    bool? isPrivate,
    bool? inAppNotifications,
    bool? pushNotifications,
    String? notificationLevel,
    DateTime? lastSyncedAt,
    DateTime? lastPrCursor,
    DateTime? lastIssueCursor,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Repository',
      if (id != null) 'id': id,
      'userId': userId,
      'owner': owner,
      'repo': repo,
      'githubRepoId': githubRepoId,
      'isPrivate': isPrivate,
      'inAppNotifications': inAppNotifications,
      'pushNotifications': pushNotifications,
      'notificationLevel': notificationLevel,
      if (lastSyncedAt != null) 'lastSyncedAt': lastSyncedAt?.toJson(),
      if (lastPrCursor != null) 'lastPrCursor': lastPrCursor?.toJson(),
      if (lastIssueCursor != null) 'lastIssueCursor': lastIssueCursor?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RepositoryImpl extends Repository {
  _RepositoryImpl({
    int? id,
    required int userId,
    required String owner,
    required String repo,
    required int githubRepoId,
    required bool isPrivate,
    required bool inAppNotifications,
    required bool pushNotifications,
    required String notificationLevel,
    DateTime? lastSyncedAt,
    DateTime? lastPrCursor,
    DateTime? lastIssueCursor,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         owner: owner,
         repo: repo,
         githubRepoId: githubRepoId,
         isPrivate: isPrivate,
         inAppNotifications: inAppNotifications,
         pushNotifications: pushNotifications,
         notificationLevel: notificationLevel,
         lastSyncedAt: lastSyncedAt,
         lastPrCursor: lastPrCursor,
         lastIssueCursor: lastIssueCursor,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Repository]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Repository copyWith({
    Object? id = _Undefined,
    int? userId,
    String? owner,
    String? repo,
    int? githubRepoId,
    bool? isPrivate,
    bool? inAppNotifications,
    bool? pushNotifications,
    String? notificationLevel,
    Object? lastSyncedAt = _Undefined,
    Object? lastPrCursor = _Undefined,
    Object? lastIssueCursor = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Repository(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      owner: owner ?? this.owner,
      repo: repo ?? this.repo,
      githubRepoId: githubRepoId ?? this.githubRepoId,
      isPrivate: isPrivate ?? this.isPrivate,
      inAppNotifications: inAppNotifications ?? this.inAppNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      notificationLevel: notificationLevel ?? this.notificationLevel,
      lastSyncedAt: lastSyncedAt is DateTime?
          ? lastSyncedAt
          : this.lastSyncedAt,
      lastPrCursor: lastPrCursor is DateTime?
          ? lastPrCursor
          : this.lastPrCursor,
      lastIssueCursor: lastIssueCursor is DateTime?
          ? lastIssueCursor
          : this.lastIssueCursor,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
