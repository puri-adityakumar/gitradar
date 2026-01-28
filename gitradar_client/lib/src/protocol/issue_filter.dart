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

abstract class IssueFilter implements _i1.SerializableModel {
  IssueFilter._({
    this.repositoryId,
    this.state,
    this.isRead,
  });

  factory IssueFilter({
    int? repositoryId,
    String? state,
    bool? isRead,
  }) = _IssueFilterImpl;

  factory IssueFilter.fromJson(Map<String, dynamic> jsonSerialization) {
    return IssueFilter(
      repositoryId: jsonSerialization['repositoryId'] as int?,
      state: jsonSerialization['state'] as String?,
      isRead: jsonSerialization['isRead'] as bool?,
    );
  }

  int? repositoryId;

  String? state;

  bool? isRead;

  /// Returns a shallow copy of this [IssueFilter]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  IssueFilter copyWith({
    int? repositoryId,
    String? state,
    bool? isRead,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'IssueFilter',
      if (repositoryId != null) 'repositoryId': repositoryId,
      if (state != null) 'state': state,
      if (isRead != null) 'isRead': isRead,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IssueFilterImpl extends IssueFilter {
  _IssueFilterImpl({
    int? repositoryId,
    String? state,
    bool? isRead,
  }) : super._(
         repositoryId: repositoryId,
         state: state,
         isRead: isRead,
       );

  /// Returns a shallow copy of this [IssueFilter]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  IssueFilter copyWith({
    Object? repositoryId = _Undefined,
    Object? state = _Undefined,
    Object? isRead = _Undefined,
  }) {
    return IssueFilter(
      repositoryId: repositoryId is int? ? repositoryId : this.repositoryId,
      state: state is String? ? state : this.state,
      isRead: isRead is bool? ? isRead : this.isRead,
    );
  }
}
