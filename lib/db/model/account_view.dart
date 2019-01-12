import 'package:hello_flutter/db/model/account.dart';
import 'package:hello_flutter/db/model/category.dart';

class AccountView {
  static final String table = 'account_view';
  static final String _accountTable = Account.table;
  static final String _categoryTable = Category.table;
  static final String sql =
    "create view $table as "
    "select $_accountTable.*, $_categoryTable.name as c_name from $_accountTable "
    "left join $_categoryTable on $_accountTable.category = $_categoryTable.id";

  Account account;
  Category category;

  AccountView.fromMap(Map<String, dynamic> map) {
    account = Account.fromMap(map);
    category = Category.fromMap(map, prefix: 'c_');
  }
}
