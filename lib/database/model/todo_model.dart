import 'package:todo/database/model/task_model.dart';

class TodoModel {
  TodoModel(this.name, {this.id, this.createdAt});

  int? id;
  String? createdAt;
  String name;

  List<TaskModel> tasks = [];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (id != null) {
      json[colId] = id;
    }
    if (createdAt != null) {
      json[colCreatedAt] = createdAt;
    }
    json[colName] = name;
    return json;
  }

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      json[colName],
      id: json[colId],
      createdAt: json[colCreatedAt],
    );
  }

  static const String tableName = 'todo';
  static const String colId = 'id';
  static const String colCreatedAt = 'createdAt';
  static const String colName = 'name';

  static String getCreateQuery() {
    return '''
      CREATE TABLE $tableName
      (
        $colId integer PRIMARY KEY AUTOINCREMENT,
        $colCreatedAt datetime DEFAULT CURRENT_TIMESTAMP,
        $colName varchar
      )
    ''';
  }
}
