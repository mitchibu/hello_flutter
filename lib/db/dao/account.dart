import 'package:hello_flutter/db/model/account.dart';

import 'dao.dart';

class AccountDao extends Dao<Account> {
  final String table = 'account';
  final String columnId = 'id';
  final String columnCategoryId = 'category_id';
  final String columnTitle = 'title';
  final String columnName = 'name';
  final String columnPassword = 'password';
  final String columnComment = 'comment';
  final String columnCreatedAt = 'created_at';
  final String columnUpdatedAt = 'updated_at';
  final String columnDeletedAt = 'deleted_at';

  @override
  String get createTableQuery =>
      "create table $table ("
      "$columnId integer primary key autoincrement,"
      "$columnCategoryId integer,"
      "$columnTitle text not null,"
      "$columnName text not null,"
      "$columnPassword text,"
      "$columnComment text,"
      "$columnCreatedAt integer not null,"
      "$columnUpdatedAt integer not null,"
      "$columnDeletedAt integer)";

  @override
  List<Account> fromList(List<Map<String, dynamic>> maps, {String prefix = ''}) {
    List<Account> list = [];
    for(Map map in maps) list.add(fromMap(map));
    return list;
  }

  @override
  Account fromMap(Map<String, dynamic> map, {String prefix = ''}) {
    return Account(
      id: map["$prefix$columnId"],
      categoryId: map["$prefix$columnCategoryId"],
      title: map["$prefix$columnTitle"],
      name: map["$prefix$columnName"],
      password: map["$prefix$columnPassword"],
      comment: map["$prefix$columnComment"],
      createdAt: map["$prefix$columnCreatedAt"],
      updatedAt: map["$prefix$columnUpdatedAt"],
      deletedAt: map["$prefix$columnDeletedAt"],
    );
  }

  @override
  Map<String, dynamic> toMap(Account obj) {
    return <String, dynamic> {
      columnId: obj.id,
      columnCategoryId: obj.categoryId,
      columnTitle: obj.title,
      columnName: obj.name,
      columnPassword: obj.password,
      columnComment: obj.comment,
      columnCreatedAt: obj.createdAt,
      columnUpdatedAt: obj.updatedAt,
      columnDeletedAt: obj.deletedAt,
    };
  }
}
