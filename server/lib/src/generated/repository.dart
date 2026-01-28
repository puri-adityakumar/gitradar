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

abstract class Repository
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = RepositoryTable();

  static const db = RepositoryRepository._();

  @override
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

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static RepositoryInclude include() {
    return RepositoryInclude._();
  }

  static RepositoryIncludeList includeList({
    _i1.WhereExpressionBuilder<RepositoryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RepositoryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RepositoryTable>? orderByList,
    RepositoryInclude? include,
  }) {
    return RepositoryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Repository.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Repository.t),
      include: include,
    );
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

class RepositoryUpdateTable extends _i1.UpdateTable<RepositoryTable> {
  RepositoryUpdateTable(super.table);

  _i1.ColumnValue<int, int> userId(int value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<String, String> owner(String value) => _i1.ColumnValue(
    table.owner,
    value,
  );

  _i1.ColumnValue<String, String> repo(String value) => _i1.ColumnValue(
    table.repo,
    value,
  );

  _i1.ColumnValue<int, int> githubRepoId(int value) => _i1.ColumnValue(
    table.githubRepoId,
    value,
  );

  _i1.ColumnValue<bool, bool> isPrivate(bool value) => _i1.ColumnValue(
    table.isPrivate,
    value,
  );

  _i1.ColumnValue<bool, bool> inAppNotifications(bool value) => _i1.ColumnValue(
    table.inAppNotifications,
    value,
  );

  _i1.ColumnValue<bool, bool> pushNotifications(bool value) => _i1.ColumnValue(
    table.pushNotifications,
    value,
  );

  _i1.ColumnValue<String, String> notificationLevel(String value) =>
      _i1.ColumnValue(
        table.notificationLevel,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> lastSyncedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.lastSyncedAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> lastPrCursor(DateTime? value) =>
      _i1.ColumnValue(
        table.lastPrCursor,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> lastIssueCursor(DateTime? value) =>
      _i1.ColumnValue(
        table.lastIssueCursor,
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

class RepositoryTable extends _i1.Table<int?> {
  RepositoryTable({super.tableRelation}) : super(tableName: 'repositories') {
    updateTable = RepositoryUpdateTable(this);
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    owner = _i1.ColumnString(
      'owner',
      this,
    );
    repo = _i1.ColumnString(
      'repo',
      this,
    );
    githubRepoId = _i1.ColumnInt(
      'githubRepoId',
      this,
    );
    isPrivate = _i1.ColumnBool(
      'isPrivate',
      this,
    );
    inAppNotifications = _i1.ColumnBool(
      'inAppNotifications',
      this,
    );
    pushNotifications = _i1.ColumnBool(
      'pushNotifications',
      this,
    );
    notificationLevel = _i1.ColumnString(
      'notificationLevel',
      this,
    );
    lastSyncedAt = _i1.ColumnDateTime(
      'lastSyncedAt',
      this,
    );
    lastPrCursor = _i1.ColumnDateTime(
      'lastPrCursor',
      this,
    );
    lastIssueCursor = _i1.ColumnDateTime(
      'lastIssueCursor',
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

  late final RepositoryUpdateTable updateTable;

  late final _i1.ColumnInt userId;

  late final _i1.ColumnString owner;

  late final _i1.ColumnString repo;

  late final _i1.ColumnInt githubRepoId;

  late final _i1.ColumnBool isPrivate;

  late final _i1.ColumnBool inAppNotifications;

  late final _i1.ColumnBool pushNotifications;

  late final _i1.ColumnString notificationLevel;

  late final _i1.ColumnDateTime lastSyncedAt;

  late final _i1.ColumnDateTime lastPrCursor;

  late final _i1.ColumnDateTime lastIssueCursor;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    owner,
    repo,
    githubRepoId,
    isPrivate,
    inAppNotifications,
    pushNotifications,
    notificationLevel,
    lastSyncedAt,
    lastPrCursor,
    lastIssueCursor,
    createdAt,
    updatedAt,
  ];
}

class RepositoryInclude extends _i1.IncludeObject {
  RepositoryInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Repository.t;
}

class RepositoryIncludeList extends _i1.IncludeList {
  RepositoryIncludeList._({
    _i1.WhereExpressionBuilder<RepositoryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Repository.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Repository.t;
}

class RepositoryRepository {
  const RepositoryRepository._();

  /// Returns a list of [Repository]s matching the given query parameters.
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
  Future<List<Repository>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RepositoryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RepositoryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RepositoryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Repository>(
      where: where?.call(Repository.t),
      orderBy: orderBy?.call(Repository.t),
      orderByList: orderByList?.call(Repository.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Repository] matching the given query parameters.
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
  Future<Repository?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RepositoryTable>? where,
    int? offset,
    _i1.OrderByBuilder<RepositoryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RepositoryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Repository>(
      where: where?.call(Repository.t),
      orderBy: orderBy?.call(Repository.t),
      orderByList: orderByList?.call(Repository.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Repository] by its [id] or null if no such row exists.
  Future<Repository?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Repository>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Repository]s in the list and returns the inserted rows.
  ///
  /// The returned [Repository]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Repository>> insert(
    _i1.Session session,
    List<Repository> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Repository>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Repository] and returns the inserted row.
  ///
  /// The returned [Repository] will have its `id` field set.
  Future<Repository> insertRow(
    _i1.Session session,
    Repository row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Repository>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Repository]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Repository>> update(
    _i1.Session session,
    List<Repository> rows, {
    _i1.ColumnSelections<RepositoryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Repository>(
      rows,
      columns: columns?.call(Repository.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Repository]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Repository> updateRow(
    _i1.Session session,
    Repository row, {
    _i1.ColumnSelections<RepositoryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Repository>(
      row,
      columns: columns?.call(Repository.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Repository] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Repository?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<RepositoryUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Repository>(
      id,
      columnValues: columnValues(Repository.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Repository]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Repository>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<RepositoryUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<RepositoryTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RepositoryTable>? orderBy,
    _i1.OrderByListBuilder<RepositoryTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Repository>(
      columnValues: columnValues(Repository.t.updateTable),
      where: where(Repository.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Repository.t),
      orderByList: orderByList?.call(Repository.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Repository]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Repository>> delete(
    _i1.Session session,
    List<Repository> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Repository>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Repository].
  Future<Repository> deleteRow(
    _i1.Session session,
    Repository row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Repository>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Repository>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<RepositoryTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Repository>(
      where: where(Repository.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RepositoryTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Repository>(
      where: where?.call(Repository.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
