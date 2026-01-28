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
import 'user.dart' as _i2;
import 'package:gitradar_client/src/protocol/protocol.dart' as _i3;

abstract class AuthResponse implements _i1.SerializableModel {
  AuthResponse._({
    required this.sessionToken,
    required this.user,
  });

  factory AuthResponse({
    required String sessionToken,
    required _i2.User user,
  }) = _AuthResponseImpl;

  factory AuthResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuthResponse(
      sessionToken: jsonSerialization['sessionToken'] as String,
      user: _i3.Protocol().deserialize<_i2.User>(jsonSerialization['user']),
    );
  }

  String sessionToken;

  _i2.User user;

  /// Returns a shallow copy of this [AuthResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AuthResponse copyWith({
    String? sessionToken,
    _i2.User? user,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AuthResponse',
      'sessionToken': sessionToken,
      'user': user.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _AuthResponseImpl extends AuthResponse {
  _AuthResponseImpl({
    required String sessionToken,
    required _i2.User user,
  }) : super._(
         sessionToken: sessionToken,
         user: user,
       );

  /// Returns a shallow copy of this [AuthResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AuthResponse copyWith({
    String? sessionToken,
    _i2.User? user,
  }) {
    return AuthResponse(
      sessionToken: sessionToken ?? this.sessionToken,
      user: user ?? this.user.copyWith(),
    );
  }
}
