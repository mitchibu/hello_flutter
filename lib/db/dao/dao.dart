abstract class Dao<T> {
  String get createTableQuery;

  List<T> fromList(List<Map<String, dynamic>> maps, {String prefix = ''});
  T fromMap(Map<String, dynamic> map, {String prefix = ''});
  Map<String, dynamic> toMap(T obj);
}
