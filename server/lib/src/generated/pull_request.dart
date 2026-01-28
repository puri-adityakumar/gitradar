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

abstract class PullRequest
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = PullRequestTable();

  static const db = PullRequestRepository._();

  @override
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

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static PullRequestInclude include() {
    return PullRequestInclude._();
  }

  static PullRequestIncludeList includeList({
    _i1.WhereExpressionBuilder<PullRequestTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PullRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PullRequestTable>? orderByList,
    PullRequestInclude? include,
  }) {
    return PullRequestIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PullRequest.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(PullRequest.t),
      include: include,
    );
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

class PullRequestUpdateTable extends _i1.UpdateTable<PullRequestTable> {
  PullRequestUpdateTable(super.table);

  _i1.ColumnValue<int, int> repositoryId(int value) => _i1.ColumnValue(
    table.repositoryId,
    value,
  );

  _i1.ColumnValue<int, int> githubId(int value) => _i1.ColumnValue(
    table.githubId,
    value,
  );

  _i1.ColumnValue<int, int> number(int value) => _i1.ColumnValue(
    table.number,
    value,
  );

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<String, String> body(String? value) => _i1.ColumnValue(
    table.body,
    value,
  );

  _i1.ColumnValue<String, String> author(String value) => _i1.ColumnValue(
    table.author,
    value,
  );

  _i1.ColumnValue<String, String> state(String value) => _i1.ColumnValue(
    table.state,
    value,
  );

  _i1.ColumnValue<String, String> htmlUrl(String value) => _i1.ColumnValue(
    table.htmlUrl,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> githubCreatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.githubCreatedAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> githubUpdatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.githubUpdatedAt,
        value,
      );

  _i1.ColumnValue<bool, bool> isRead(bool value) => _i1.ColumnValue(
    table.isRead,
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

class PullRequestTable extends _i1.Table<int?> {
  PullRequestTable({super.tableRelation}) : super(tableName: 'pull_requests') {
    updateTable = PullRequestUpdateTable(this);
    repositoryId = _i1.ColumnInt(
      'repositoryId',
      this,
    );
    githubId = _i1.ColumnInt(
      'githubId',
      this,
    );
    number = _i1.ColumnInt(
      'number',
      this,
    );
    title = _i1.ColumnString(
      'title',
      this,
    );
    body = _i1.ColumnString(
      'body',
      this,
    );
    author = _i1.ColumnString(
      'author',
      this,
    );
    state = _i1.ColumnString(
      'state',
      this,
    );
    htmlUrl = _i1.ColumnString(
      'htmlUrl',
      this,
    );
    githubCreatedAt = _i1.ColumnDateTime(
      'githubCreatedAt',
      this,
    );
    githubUpdatedAt = _i1.ColumnDateTime(
      'githubUpdatedAt',
      this,
    );
    isRead = _i1.ColumnBool(
      'isRead',
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

  late final PullRequestUpdateTable updateTable;

  late final _i1.ColumnInt repositoryId;

  late final _i1.ColumnInt githubId;

  late final _i1.ColumnInt number;

  late final _i1.ColumnString title;

  late final _i1.ColumnString body;

  late final _i1.ColumnString author;

  late final _i1.ColumnString state;

  late final _i1.ColumnString htmlUrl;

  late final _i1.ColumnDateTime githubCreatedAt;

  late final _i1.ColumnDateTime githubUpdatedAt;

  late final _i1.ColumnBool isRead;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    repositoryId,
    githubId,
    number,
    title,
    body,
    author,
    state,
    htmlUrl,
    githubCreatedAt,
    githubUpdatedAt,
    isRead,
    createdAt,
    updatedAt,
  ];
}

class PullRequestInclude extends _i1.IncludeObject {
  PullRequestInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => PullRequest.t;
}

class PullRequestIncludeList extends _i1.IncludeList {
  PullRequestIncludeList._({
    _i1.WhereExpressionBuilder<PullRequestTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PullRequest.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => PullRequest.t;
}

class PullRequestRepository {
  const PullRequestRepository._();

  /// Returns a list of [PullRequest]s matching the given query parameters.
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
  Future<List<PullRequest>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PullRequestTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PullRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PullRequestTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<PullRequest>(
      where: where?.call(PullRequest.t),
      orderBy: orderBy?.call(PullRequest.t),
      orderByList: orderByList?.call(PullRequest.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [PullRequest] matching the given query parameters.
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
  Future<PullRequest?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PullRequestTable>? where,
    int? offset,
    _i1.OrderByBuilder<PullRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PullRequestTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<PullRequest>(
      where: where?.call(PullRequest.t),
      orderBy: orderBy?.call(PullRequest.t),
      orderByList: orderByList?.call(PullRequest.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [PullRequest] by its [id] or null if no such row exists.
  Future<PullRequest?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<PullRequest>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [PullRequest]s in the list and returns the inserted rows.
  ///
  /// The returned [PullRequest]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<PullRequest>> insert(
    _i1.Session session,
    List<PullRequest> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<PullRequest>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [PullRequest] and returns the inserted row.
  ///
  /// The returned [PullRequest] will have its `id` field set.
  Future<PullRequest> insertRow(
    _i1.Session session,
    PullRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<PullRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [PullRequest]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<PullRequest>> update(
    _i1.Session session,
    List<PullRequest> rows, {
    _i1.ColumnSelections<PullRequestTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<PullRequest>(
      rows,
      columns: columns?.call(PullRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PullRequest]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PullRequest> updateRow(
    _i1.Session session,
    PullRequest row, {
    _i1.ColumnSelections<PullRequestTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<PullRequest>(
      row,
      columns: columns?.call(PullRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PullRequest] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PullRequest?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<PullRequestUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<PullRequest>(
      id,
      columnValues: columnValues(PullRequest.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PullRequest]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<PullRequest>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<PullRequestUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<PullRequestTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PullRequestTable>? orderBy,
    _i1.OrderByListBuilder<PullRequestTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<PullRequest>(
      columnValues: columnValues(PullRequest.t.updateTable),
      where: where(PullRequest.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PullRequest.t),
      orderByList: orderByList?.call(PullRequest.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [PullRequest]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<PullRequest>> delete(
    _i1.Session session,
    List<PullRequest> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<PullRequest>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [PullRequest].
  Future<PullRequest> deleteRow(
    _i1.Session session,
    PullRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PullRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<PullRequest>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PullRequestTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<PullRequest>(
      where: where(PullRequest.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PullRequestTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<PullRequest>(
      where: where?.call(PullRequest.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
