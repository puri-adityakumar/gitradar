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

abstract class UserPreferences implements _i1.SerializableModel {
  UserPreferences._({
    this.id,
    required this.userId,
    required this.themeMode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory UserPreferences({
    int? id,
    required int userId,
    required String themeMode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserPreferencesImpl;

  factory UserPreferences.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserPreferences(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      themeMode: jsonSerialization['themeMode'] as String,
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

  String themeMode;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [UserPreferences]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserPreferences copyWith({
    int? id,
    int? userId,
    String? themeMode,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserPreferences',
      if (id != null) 'id': id,
      'userId': userId,
      'themeMode': themeMode,
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

class _UserPreferencesImpl extends UserPreferences {
  _UserPreferencesImpl({
    int? id,
    required int userId,
    required String themeMode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         themeMode: themeMode,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [UserPreferences]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserPreferences copyWith({
    Object? id = _Undefined,
    int? userId,
    String? themeMode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserPreferences(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      themeMode: themeMode ?? this.themeMode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
