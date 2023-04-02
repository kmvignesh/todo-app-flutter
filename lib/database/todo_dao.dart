import 'package:sqflite/sqlite_api.dart';
import 'package:todo/database/model/todo_model.dart';

class TodoDao {
  // add Todo
  Future<void> addTodo(Database db, TodoModel todoModel) async {
    await db.insert(TodoModel.tableName, todoModel.toJson());
  }

  // update Todo
  Future<void> updateTodo(Database db, TodoModel todoModel) async {
    await db.update(
      TodoModel.tableName,
      todoModel.toJson(),
      where: '${TodoModel.colId} = ?',
      whereArgs: [todoModel.id],
    );
  }

// delete Todo
  Future<void> deleteTodo(Database db, TodoModel todoModel) async {
    await db.delete(
      TodoModel.tableName,
      where: '${TodoModel.colId} = ?',
      whereArgs: [todoModel.id],
    );
  }

// read Todo
  Future<List<TodoModel>> getTodos(Database db) async {
    List<TodoModel> result = [];
    List queryResults = await db.query(TodoModel.tableName);
    for (var queryResult in queryResults) {
      result.add(TodoModel.fromJson(queryResult));
    }
    return result;
  }
}
