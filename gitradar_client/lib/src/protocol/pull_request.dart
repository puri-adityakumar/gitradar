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

abstract class PullRequest implements _i1.SerializableModel {
  PullRequest._({
    this.id,
    required this.repositoryId,
    required this.githubId,
    required this.number,
    required this.title,
    this.body,
    required this.author,
    required this.state,
    required this.htmlUrl,
    required this.githubCreatedAt,
    required this.githubUpdatedAt,
    required this.isRead,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory PullRequest({
    int? id,
    required int repositoryId,
    required int githubId,
    required int number,
    required String title,
    String? body,
    required String author,
    required String state,
    required String htmlUrl,
    required DateTime githubCreatedAt,
    required DateTime githubUpdatedAt,
    required bool isRead,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _PullRequestImpl;

  factory PullRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return PullRequest(
      id: jsonSerialization['id'] as int?,
      repositoryId: jsonSerialization['repositoryId'] as int,
      githubId: jsonSerialization['githubId'] as int,
      number: jsonSerialization['number'] as int,
      title: jsonSerialization['title'] as String,
      body: jsonSerialization['body'] as String?,
      author: jsonSerialization['author'] as String,
      state: jsonSerialization['state'] as String,
      htmlUrl: jsonSerialization['htmlUrl'] as String,
      githubCreatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['githubCreatedAt'],
      ),
      githubUpdatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['githubUpdatedAt'],
      ),
      isRead: jsonSerialization['isRead'] as bool,
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

  int repositoryId;

  int githubId;

  int number;

  String title;

  String? body;

  String author;

  String state;

  String htmlUrl;

  DateTime githubCreatedAt;

  DateTime githubUpdatedAt;

  bool isRead;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [PullRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PullRequest copyWith({
    int? id,
    int? repositoryId,
    int? githubId,
    int? number,
    String? title,
    String? body,
    String? author,
    String? state,
    String? htmlUrl,
    DateTime? githubCreatedAt,
    DateTime? githubUpdatedAt,
    bool? isRead,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PullRequest',
      if (id != null) 'id': id,
      'repositoryId': repositoryId,
      'githubId': githubId,
      'number': number,
      'title': title,
      if (body != null) 'body': body,
      'author': author,
      'state': state,
      'htmlUrl': htmlUrl,
      'githubCreatedAt': githubCreatedAt.toJson(),
      'githubUpdatedAt': githubUpdatedAt.toJson(),
      'isRead': isRead,
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

class _PullRequestImpl extends PullRequest {
  _PullRequestImpl({
    int? id,
    required int repositoryId,
    required int githubId,
    required int number,
    required String title,
    String? body,
    required String author,
    required String state,
    required String htmlUrl,
    required DateTime githubCreatedAt,
    required DateTime githubUpdatedAt,
    required bool isRead,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         repositoryId: repositoryId,
         githubId: githubId,
         number: number,
         title: title,
         body: body,
         author: author,
         state: state,
         htmlUrl: htmlUrl,
         githubCreatedAt: githubCreatedAt,
         githubUpdatedAt: githubUpdatedAt,
         isRead: isRead,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [PullRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PullRequest copyWith({
    Object? id = _Undefined,
    int? repositoryId,
    int? githubId,
    int? number,
    String? title,
    Object? body = _Undefined,
    String? author,
    String? state,
    String? htmlUrl,
    DateTime? githubCreatedAt,
    DateTime? githubUpdatedAt,
    bool? isRead,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PullRequest(
      id: id is int? ? id : this.id,
      repositoryId: repositoryId ?? this.repositoryId,
      githubId: githubId ?? this.githubId,
      number: number ?? this.number,
      title: title ?? this.title,
      body: body is String? ? body : this.body,
      author: author ?? this.author,
      state: state ?? this.state,
      htmlUrl: htmlUrl ?? this.htmlUrl,
      githubCreatedAt: githubCreatedAt ?? this.githubCreatedAt,
      githubUpdatedAt: githubUpdatedAt ?? this.githubUpdatedAt,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
