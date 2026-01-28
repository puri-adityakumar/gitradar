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
import 'notification.dart' as _i2;
import 'package:gitradar_server/src/generated/protocol.dart' as _i3;

abstract class PaginatedNotifications
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  PaginatedNotifications._({
    required this.items,
    this.nextCursor,
    required this.hasMore,
  });

  factory PaginatedNotifications({
    required List<_i2.Notification> items,
    String? nextCursor,
    required bool hasMore,
  }) = _PaginatedNotificationsImpl;

  factory PaginatedNotifications.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return PaginatedNotifications(
      items: _i3.Protocol().deserialize<List<_i2.Notification>>(
        jsonSerialization['items'],
      ),
      nextCursor: jsonSerialization['nextCursor'] as String?,
      hasMore: jsonSerialization['hasMore'] as bool,
    );
  }

  List<_i2.Notification> items;

  String? nextCursor;

  bool hasMore;

  /// Returns a shallow copy of this [PaginatedNotifications]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PaginatedNotifications copyWith({
    List<_i2.Notification>? items,
    String? nextCursor,
    bool? hasMore,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PaginatedNotifications',
      'items': items.toJson(valueToJson: (v) => v.toJson()),
      if (nextCursor != null) 'nextCursor': nextCursor,
      'hasMore': hasMore,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PaginatedNotifications',
      'items': items.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (nextCursor != null) 'nextCursor': nextCursor,
      'hasMore': hasMore,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PaginatedNotificationsImpl extends PaginatedNotifications {
  _PaginatedNotificationsImpl({
    required List<_i2.Notification> items,
    String? nextCursor,
    required bool hasMore,
  }) : super._(
         items: items,
         nextCursor: nextCursor,
         hasMore: hasMore,
       );

  /// Returns a shallow copy of this [PaginatedNotifications]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PaginatedNotifications copyWith({
    List<_i2.Notification>? items,
    Object? nextCursor = _Undefined,
    bool? hasMore,
  }) {
    return PaginatedNotifications(
      items: items ?? this.items.map((e0) => e0.copyWith()).toList(),
      nextCursor: nextCursor is String? ? nextCursor : this.nextCursor,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
