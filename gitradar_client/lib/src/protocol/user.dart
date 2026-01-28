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

abstract class User implements _i1.SerializableModel {
  User._({
    this.id,
    this.githubId,
    this.githubUsername,
    this.displayName,
    this.avatarUrl,
    this.deviceId,
    required this.isAnonymous,
    this.onesignalPlayerId,
    this.lastValidatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory User({
    int? id,
    int? githubId,
    String? githubUsername,
    String? displayName,
    String? avatarUrl,
    String? deviceId,
    required bool isAnonymous,
    String? onesignalPlayerId,
    DateTime? lastValidatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserImpl;

  factory User.fromJson(Map<String, dynamic> jsonSerialization) {
    return User(
      id: jsonSerialization['id'] as int?,
      githubId: jsonSerialization['githubId'] as int?,
      githubUsername: jsonSerialization['githubUsername'] as String?,
      displayName: jsonSerialization['displayName'] as String?,
      avatarUrl: jsonSerialization['avatarUrl'] as String?,
      deviceId: jsonSerialization['deviceId'] as String?,
      isAnonymous: jsonSerialization['isAnonymous'] as bool,
      onesignalPlayerId: jsonSerialization['onesignalPlayerId'] as String?,
      lastValidatedAt: jsonSerialization['lastValidatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastValidatedAt'],
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

  int? githubId;

  String? githubUsername;

  String? displayName;

  String? avatarUrl;

  String? deviceId;

  bool isAnonymous;

  String? onesignalPlayerId;

  DateTime? lastValidatedAt;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [User]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  User copyWith({
    int? id,
    int? githubId,
    String? githubUsername,
    String? displayName,
    String? avatarUrl,
    String? deviceId,
    bool? isAnonymous,
    String? onesignalPlayerId,
    DateTime? lastValidatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'User',
      if (id != null) 'id': id,
      if (githubId != null) 'githubId': githubId,
      if (githubUsername != null) 'githubUsername': githubUsername,
      if (displayName != null) 'displayName': displayName,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
      if (deviceId != null) 'deviceId': deviceId,
      'isAnonymous': isAnonymous,
      if (onesignalPlayerId != null) 'onesignalPlayerId': onesignalPlayerId,
      if (lastValidatedAt != null) 'lastValidatedAt': lastValidatedAt?.toJson(),
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

class _UserImpl extends User {
  _UserImpl({
    int? id,
    int? githubId,
    String? githubUsername,
    String? displayName,
    String? avatarUrl,
    String? deviceId,
    required bool isAnonymous,
    String? onesignalPlayerId,
    DateTime? lastValidatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         githubId: githubId,
         githubUsername: githubUsername,
         displayName: displayName,
         avatarUrl: avatarUrl,
         deviceId: deviceId,
         isAnonymous: isAnonymous,
         onesignalPlayerId: onesignalPlayerId,
         lastValidatedAt: lastValidatedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [User]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  User copyWith({
    Object? id = _Undefined,
    Object? githubId = _Undefined,
    Object? githubUsername = _Undefined,
    Object? displayName = _Undefined,
    Object? avatarUrl = _Undefined,
    Object? deviceId = _Undefined,
    bool? isAnonymous,
    Object? onesignalPlayerId = _Undefined,
    Object? lastValidatedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id is int? ? id : this.id,
      githubId: githubId is int? ? githubId : this.githubId,
      githubUsername: githubUsername is String?
          ? githubUsername
          : this.githubUsername,
      displayName: displayName is String? ? displayName : this.displayName,
      avatarUrl: avatarUrl is String? ? avatarUrl : this.avatarUrl,
      deviceId: deviceId is String? ? deviceId : this.deviceId,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      onesignalPlayerId: onesignalPlayerId is String?
          ? onesignalPlayerId
          : this.onesignalPlayerId,
      lastValidatedAt: lastValidatedAt is DateTime?
          ? lastValidatedAt
          : this.lastValidatedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
