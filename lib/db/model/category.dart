import 'package:meta/meta.dart';

const String _ID = 'id';
const String _NAME = 'name';

class Category {
  static final String table = 'category';
  static final String sql =
    "create table $table ("
    "$_ID integer primary key autoincrement,"
    "$_NAME text not null)";

  int id;
  String name;

  Category({
    @required this.name,
  });

  Category.fromMap(Map<String, dynamic> map, {String prefix}) {
    id = map["$prefix$_ID"];
    name = map["$prefix$_NAME"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      _NAME:name
    };
    if(id != null) map[_ID] = id;
    return map;
  }
}
