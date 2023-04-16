import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/database/model/task_model.dart';
import 'package:todo/database/model/todo_model.dart';

class TodoDatabase {
  TodoDatabase._internal();

  static final TodoDatabase _instance = TodoDatabase._internal();

  factory TodoDatabase() {
    return _instance;
  }

  late Database _database;

  Database get database => _database;

  String dbName = "TodoList";
  int dbVersion = 2;

  Future<void> initialise() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, '$dbName.db');
    // open the database
    _database = await openDatabase(path, version: dbVersion,
        onCreate: (Database db, int version) async {
      await db.execute(TodoModel.getCreateQuery());
      await db.execute(TaskModel.getCreateQuery());
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      if (oldVersion == 1 && newVersion == 2) {
        await db.execute(TaskModel.getCreateQuery());
      }
    });
  }
}
