import 'package:hello_flutter/db/model/account_view.dart';

import 'account.dart';
import 'category.dart';
import 'dao.dart';

class AccountViewDao extends Dao<AccountView> {
  static final AccountDao accountDao = AccountDao();
  static final CategoryDao categoryDao = CategoryDao();

  final String table = 'account_view';

  @override
  String get createTableQuery =>
      "create view $table as "
      "select ${accountDao.table}.*, ${categoryDao.table}.${categoryDao.columnName} as c_${categoryDao.columnName} from ${accountDao.table} "
      "left join ${categoryDao.table} on ${accountDao.table}.${accountDao.columnCategoryId} = ${categoryDao.table}.${categoryDao.columnId}";

  @override
  List<AccountView> fromList(List<Map<String, dynamic>> maps, {String prefix = ''}) {
    List<AccountView> list = [];
    for(Map map in maps) {
      list.add(fromMap(map));
    }
    return list;
  }

  @override
  AccountView fromMap(Map<String, dynamic> map, {String prefix = ''}) {
    return AccountView(
      AccountDao().fromMap(map),
      CategoryDao().fromMap(map, prefix: 'c_')
    );
  }

  @override
  Map<String, dynamic> toMap(AccountView obj) {
    throw StateError("not supported");
  }
}
