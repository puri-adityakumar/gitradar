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

abstract class Notification implements _i1.SerializableModel {
  Notification._({
    this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    required this.repositoryId,
    this.pullRequestId,
    this.issueId,
    required this.isRead,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Notification({
    int? id,
    required int userId,
    required String type,
    required String title,
    required String message,
    required int repositoryId,
    int? pullRequestId,
    int? issueId,
    required bool isRead,
    DateTime? createdAt,
  }) = _NotificationImpl;

  factory Notification.fromJson(Map<String, dynamic> jsonSerialization) {
    return Notification(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      type: jsonSerialization['type'] as String,
      title: jsonSerialization['title'] as String,
      message: jsonSerialization['message'] as String,
      repositoryId: jsonSerialization['repositoryId'] as int,
      pullRequestId: jsonSerialization['pullRequestId'] as int?,
      issueId: jsonSerialization['issueId'] as int?,
      isRead: jsonSerialization['isRead'] as bool,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userId;

  String type;

  String title;

  String message;

  int repositoryId;

  int? pullRequestId;

  int? issueId;

  bool isRead;

  DateTime createdAt;

  /// Returns a shallow copy of this [Notification]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Notification copyWith({
    int? id,
    int? userId,
    String? type,
    String? title,
    String? message,
    int? repositoryId,
    int? pullRequestId,
    int? issueId,
    bool? isRead,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Notification',
      if (id != null) 'id': id,
      'userId': userId,
      'type': type,
      'title': title,
      'message': message,
      'repositoryId': repositoryId,
      if (pullRequestId != null) 'pullRequestId': pullRequestId,
      if (issueId != null) 'issueId': issueId,
      'isRead': isRead,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotificationImpl extends Notification {
  _NotificationImpl({
    int? id,
    required int userId,
    required String type,
    required String title,
    required String message,
    required int repositoryId,
    int? pullRequestId,
    int? issueId,
    required bool isRead,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userId: userId,
         type: type,
         title: title,
         message: message,
         repositoryId: repositoryId,
         pullRequestId: pullRequestId,
         issueId: issueId,
         isRead: isRead,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Notification]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Notification copyWith({
    Object? id = _Undefined,
    int? userId,
    String? type,
    String? title,
    String? message,
    int? repositoryId,
    Object? pullRequestId = _Undefined,
    Object? issueId = _Undefined,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return Notification(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      repositoryId: repositoryId ?? this.repositoryId,
      pullRequestId: pullRequestId is int? ? pullRequestId : this.pullRequestId,
      issueId: issueId is int? ? issueId : this.issueId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
