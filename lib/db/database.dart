import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'model/account.dart';

class DatabaseHelper {
  static DatabaseHelper _singleton;

  factory DatabaseHelper({
    String name = ':memory:',
    int version = 1,
  }) {
    if(_singleton == null) {
      _singleton = DatabaseHelper._(name, version);
    } else {
      assert(_singleton._name != name);
    }
    return _singleton;
  }

  static Database _db;

  final String _name;
  final int _version;

  DatabaseHelper._(this._name, this._version);

  Future<Database> get db async {
    return _db == null ? await _init() : _db;
  }
  
  _init() async {
    return await openDatabase(
      _name == ':memory:' ? _name : join(await getDatabasesPath(), _name),
      version: _version,
      onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    print(Account.sql);
    await db.execute(Account.sql);

    // test data
    await db.transaction((t) async {
      var batch = t.batch();
      for(int i = 0; i < 100; ++ i) {
        batch.insert(Account.table, Account(title: "title$i", name: "name$i").toMap());
      }
      await batch.commit();
    });
  }

  Future<int> insert(String table, Map<String, dynamic> data) async {
    return await (await db).insert(table, data);
  }

  Future<int> update(String table, Map<String, dynamic> data, String where, List<dynamic> whereArgs) async {
    return await (await db).update(table, data, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(String table, String where, List<dynamic> whereArgs) async {
    return await (await db).delete(table, where: where, whereArgs: whereArgs);
  }

  Future insertAll(String table, List<Map<String, dynamic>> data) async {
    return (await db).transaction((t) async {
      var batch = t.batch();
      for(var record in data) {
        batch.insert(table, record);
      }
      await batch.commit();
    });
  }

  Future<List<Map<String, dynamic>>> query(String table, {int limit, int offset}) async {
    return await (await db).query(table,
      limit: limit,
      offset: offset);
  }

  Future<List<Account>> getAccount({int limit, int offset}) async {
    List<Account> accounts = [];
    List<Map<String, dynamic>> data = await (await db).query(Account.table,
      where: "deteled_at is null",
      limit: limit,
      offset: offset,);
    for(var record in data) {
      accounts.add(Account.fromMap(record));
    }
    return accounts;
  }
}
