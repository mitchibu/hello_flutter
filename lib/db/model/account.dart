import 'package:meta/meta.dart';

class Account {
  int id;
  int categoryId;
  String title;
  String name;
  String password;
  String comment;
  int createdAt;
  int updatedAt;
  int deletedAt;

  Account({
    this.id,
    this.categoryId,
    @required this.title,
    @required this.name,
    this.password,
    this.comment,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  }) {
    var now = new DateTime.now();
    createdAt ??= now.millisecond; 
    updatedAt ??= now.millisecond; 
  }
}
