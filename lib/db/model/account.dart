const String _ID = 'id';
const String _TITLE = 'title';
const String _NAME = 'name';

class Account {
  static final String table = 'account';
  static final String sql =
    "create table $table ("
    "$_ID integer primary key autoincrement,"
    "$_TITLE text not null,"
    "$_NAME text not null)";

  int id;
  String title;
  String name;

  Account({
    this.title,
    this.name
  });

  Account.fromMap(Map<String, dynamic> map) {
    id = map[_ID];
    title = map[_TITLE];
    name = map[_NAME];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {_TITLE:title, _NAME:name};
    if(id != null) map[_ID] = id;
    return map;
  }
}
