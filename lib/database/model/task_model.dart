class TaskModel {
  TaskModel(
    this.name,
    this.isCompleted,
    this.sequence,
    this.todoId, {
    this.id,
    this.createdAt,
  });

  int? id;
  String? createdAt;
  String name;
  bool isCompleted;
  int sequence;
  int todoId;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (id != null) {
      json[colId] = id;
    }
    if (createdAt != null) {
      json[colCreatedAt] = createdAt;
    }
    json[colName] = name;
    json[colIsCompleted] = isCompleted ? 1 : 0;
    json[colSequence] = sequence;
    json[colTodoId] = todoId;
    return json;
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      json[colName],
      json[colIsCompleted] == 1,
      json[colSequence],
      json[colTodoId],
      id: json[colId],
      createdAt: json[colCreatedAt],
    );
  }

  static const String tableName = 'task';
  static const String colId = 'id';
  static const String colCreatedAt = 'createdAt';
  static const String colName = 'name';
  static const String colIsCompleted = 'isCompleted';
  static const String colSequence = 'sequence';
  static const String colTodoId = 'todoId';

  static String getCreateQuery() {
    return '''
      CREATE TABLE $tableName
      (
        $colId integer PRIMARY KEY AUTOINCREMENT,
        $colCreatedAt datetime DEFAULT CURRENT_TIMESTAMP,
        $colName varchar,
        $colIsCompleted integer,
        $colSequence integer,
        $colTodoId integer
      )
    ''';
  }
}
