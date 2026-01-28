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

abstract class UserPreferences
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = UserPreferencesTable();

  static const db = UserPreferencesRepository._();

  @override
  int? id;

  int userId;

  String themeMode;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserPreferences',
      if (id != null) 'id': id,
      'userId': userId,
      'themeMode': themeMode,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static UserPreferencesInclude include() {
    return UserPreferencesInclude._();
  }

  static UserPreferencesIncludeList includeList({
    _i1.WhereExpressionBuilder<UserPreferencesTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserPreferencesTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserPreferencesTable>? orderByList,
    UserPreferencesInclude? include,
  }) {
    return UserPreferencesIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserPreferences.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserPreferences.t),
      include: include,
    );
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

class UserPreferencesUpdateTable extends _i1.UpdateTable<UserPreferencesTable> {
  UserPreferencesUpdateTable(super.table);

  _i1.ColumnValue<int, int> userId(int value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<String, String> themeMode(String value) => _i1.ColumnValue(
    table.themeMode,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );
}

class UserPreferencesTable extends _i1.Table<int?> {
  UserPreferencesTable({super.tableRelation})
    : super(tableName: 'user_preferences') {
    updateTable = UserPreferencesUpdateTable(this);
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    themeMode = _i1.ColumnString(
      'themeMode',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
      hasDefault: true,
    );
  }

  late final UserPreferencesUpdateTable updateTable;

  late final _i1.ColumnInt userId;

  late final _i1.ColumnString themeMode;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    themeMode,
    createdAt,
    updatedAt,
  ];
}

class UserPreferencesInclude extends _i1.IncludeObject {
  UserPreferencesInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => UserPreferences.t;
}

class UserPreferencesIncludeList extends _i1.IncludeList {
  UserPreferencesIncludeList._({
    _i1.WhereExpressionBuilder<UserPreferencesTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserPreferences.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => UserPreferences.t;
}

class UserPreferencesRepository {
  const UserPreferencesRepository._();

  /// Returns a list of [UserPreferences]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<UserPreferences>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserPreferencesTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserPreferencesTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserPreferencesTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<UserPreferences>(
      where: where?.call(UserPreferences.t),
      orderBy: orderBy?.call(UserPreferences.t),
      orderByList: orderByList?.call(UserPreferences.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [UserPreferences] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<UserPreferences?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserPreferencesTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserPreferencesTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserPreferencesTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<UserPreferences>(
      where: where?.call(UserPreferences.t),
      orderBy: orderBy?.call(UserPreferences.t),
      orderByList: orderByList?.call(UserPreferences.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [UserPreferences] by its [id] or null if no such row exists.
  Future<UserPreferences?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<UserPreferences>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [UserPreferences]s in the list and returns the inserted rows.
  ///
  /// The returned [UserPreferences]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<UserPreferences>> insert(
    _i1.Session session,
    List<UserPreferences> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UserPreferences>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [UserPreferences] and returns the inserted row.
  ///
  /// The returned [UserPreferences] will have its `id` field set.
  Future<UserPreferences> insertRow(
    _i1.Session session,
    UserPreferences row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserPreferences>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UserPreferences]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UserPreferences>> update(
    _i1.Session session,
    List<UserPreferences> rows, {
    _i1.ColumnSelections<UserPreferencesTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserPreferences>(
      rows,
      columns: columns?.call(UserPreferences.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserPreferences]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserPreferences> updateRow(
    _i1.Session session,
    UserPreferences row, {
    _i1.ColumnSelections<UserPreferencesTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserPreferences>(
      row,
      columns: columns?.call(UserPreferences.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserPreferences] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UserPreferences?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<UserPreferencesUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<UserPreferences>(
      id,
      columnValues: columnValues(UserPreferences.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UserPreferences]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<UserPreferences>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<UserPreferencesUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<UserPreferencesTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserPreferencesTable>? orderBy,
    _i1.OrderByListBuilder<UserPreferencesTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<UserPreferences>(
      columnValues: columnValues(UserPreferences.t.updateTable),
      where: where(UserPreferences.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserPreferences.t),
      orderByList: orderByList?.call(UserPreferences.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [UserPreferences]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UserPreferences>> delete(
    _i1.Session session,
    List<UserPreferences> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserPreferences>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UserPreferences].
  Future<UserPreferences> deleteRow(
    _i1.Session session,
    UserPreferences row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserPreferences>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UserPreferences>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserPreferencesTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserPreferences>(
      where: where(UserPreferences.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserPreferencesTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserPreferences>(
      where: where?.call(UserPreferences.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
