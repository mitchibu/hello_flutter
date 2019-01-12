import 'package:meta/meta.dart';

const String _ID = 'id';
const String _CATEGORY = 'category';
const String _TITLE = 'title';
const String _NAME = 'name';
const String _CREATED_AT = 'created_at';
const String _UPDATED_AT = 'updated_at';
const String _DELETED_AT = 'deleted_at';

class Account {
  static final String table = 'account';
  static final String sql =
    "create table $table ("
    "$_ID integer primary key autoincrement,"
    "$_CATEGORY integer,"
    "$_TITLE text not null,"
    "$_NAME text not null,"
    "$_CREATED_AT integer not null,"
    "$_UPDATED_AT integer not null,"
    "$_DELETED_AT integer)";

  int id;
  int category;
  String title;
  String name;
  int createdAt;
  int updatedAt;
  int deletedAt;

  Account({
    this.category,
    @required this.title,
    @required this.name,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  }) {
    createdAt ??= DateTime.now().millisecond; 
    updatedAt ??= DateTime.now().millisecond; 
  }

  Account.fromMap(Map<String, dynamic> map, {String prefix = ''}) {
    id = map["$prefix$_ID"];
    category = map["$prefix$_CATEGORY"];
    title = map["$prefix$_TITLE"];
    name = map["$prefix$_NAME"];
    createdAt = map["$prefix$_CREATED_AT"];
    updatedAt = map["$prefix$_UPDATED_AT"];
    deletedAt = map["$prefix$_DELETED_AT"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      _TITLE:title,
      _NAME:name,
      _CREATED_AT:createdAt,
      _UPDATED_AT:updatedAt
    };
    if(id != null) map[_ID] = id;
    if(category != null) map[_CATEGORY] = category;
    if(deletedAt != null) map[_DELETED_AT] = deletedAt;
    return map;
  }
}
