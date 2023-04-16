import 'package:sqflite/sqflite.dart';
import 'package:todo/database/model/task_model.dart';

class TaskDao {
  // addTask
  Future<void> addTask(Database db, TaskModel taskModel) async {
    db.insert(TaskModel.tableName, taskModel.toJson());
  }

  // updateTask
  Future<void> updateTask(Database db, TaskModel taskModel) async {
    db.update(TaskModel.tableName, taskModel.toJson(),
        where: '${TaskModel.colId}=?', whereArgs: [taskModel.id]);
  }

  // deleteTask
  Future<void> deleteTask(Database db, int taskId) async {
    db.delete(TaskModel.tableName,
        where: '${TaskModel.colId}=?', whereArgs: [taskId]);
  }

  // readTask
  Future<List<TaskModel>> getTask(Database db, int todoId) async {
    List<TaskModel> result = [];
    List queryResults = await db.query(
      TaskModel.tableName,
      where: '${TaskModel.colTodoId}=?',
      whereArgs: [todoId],
      orderBy: TaskModel.colSequence,
    );
    for (var queryResult in queryResults) {
      result.add(TaskModel.fromJson(queryResult));
    }
    return result;
  }

  // mark all task as completed
  Future<void> markTaskAsCompleted(Database db, int todoId) async {
    await db.rawUpdate(
      'UPDATE ${TaskModel.tableName} SET ${TaskModel.colIsCompleted} = ? WHERE ${TaskModel.colTodoId}=?',
      [1, todoId],
    );
  }
}
