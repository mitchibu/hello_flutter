import 'package:hello_flutter/db/dao/account.dart';
import 'package:hello_flutter/db/dao/account_view.dart';
import 'package:hello_flutter/db/dao/category.dart';
import 'package:hello_flutter/db/model/account.dart';
import 'package:hello_flutter/db/model/account_view.dart';
import 'package:hello_flutter/db/model/category.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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

  final AccountDao accountDao = AccountDao();
  final AccountViewDao accountViewDao = AccountViewDao();
  final CategoryDao categoryDao = CategoryDao();
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
    await db.execute(accountDao.createTableQuery);
    await db.execute(categoryDao.createTableQuery);
    await db.execute(accountViewDao.createTableQuery);

    // test data
    await db.transaction((t) async {
      var batch = t.batch();
      for(int i = 0; i < 100; ++ i) {
        batch.insert(accountDao.table, accountDao.toMap(Account(categoryId: 1, title: "title$i", name: "name$i", password: "pass$i")));
      }
      for(int i = 0; i < 10; ++ i) {
        batch.insert(categoryDao.table, categoryDao.toMap(Category(name: "test$i")));
      }
      await batch.commit();
    });
  }

  Future<List<Category>> getCategories({int limit, int offset}) async {
    return categoryDao.fromList(await (await db).query(
      categoryDao.table,
      limit: limit,
      offset: offset,)
    );
  }

  Future<List<AccountView>> getAccountView({int limit, int offset}) async {
    return accountViewDao.fromList(await (await db).query(
      accountViewDao.table,
      where: "${accountDao.columnDeletedAt} is null",
      limit: limit,
      offset: offset,)
    );
  }

  Future deleteAccount(Account account, {bool isLogical = false}) async {
    if(isLogical) {
      account.deletedAt = DateTime.now().millisecond;
      await (await db).update(
        accountDao.table,
        accountDao.toMap(account),
        where: "${accountDao.columnId} == ?",
        whereArgs: [account.id],
      );
    } else {
      await (await db).delete(
        accountDao.table,
        where: "${accountDao.columnId} == ?",
        whereArgs: [account.id],
      );
    }
  }
}
