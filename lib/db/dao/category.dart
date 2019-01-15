import 'package:hello_flutter/db/model/category.dart';

import 'dao.dart';

class CategoryDao extends Dao<Category> {
  final String table = 'category';
  final String columnId = 'id';
  final String columnName = 'name';

  @override
  String get createTableQuery =>
      "create table $table ("
      "$columnId integer primary key autoincrement,"
      "$columnName text not null)";

  @override
  List<Category> fromList(List<Map<String, dynamic>> maps, {String prefix = ''}) {
    List<Category> list = [];
    for(Map map in maps) list.add(fromMap(map));
    return list;
  }

  @override
  Category fromMap(Map<String, dynamic> map, {String prefix = ''}) {
    return Category(
      id: map["$prefix$columnId"],
      name: map["$prefix$columnName"],
    );
  }

  @override
  Map<String, dynamic> toMap(Category obj) {
    return <String, dynamic> {
      columnId: obj.id,
      columnName: obj.name,
    };
  }
}
