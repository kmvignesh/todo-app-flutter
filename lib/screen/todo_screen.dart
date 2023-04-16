import 'package:flutter/material.dart';
import 'package:todo/common/enums.dart';
import 'package:todo/database/model/todo_model.dart';
import 'package:todo/database/task_dao.dart';
import 'package:todo/database/todo_dao.dart';
import 'package:todo/database/todo_database.dart';
import 'package:todo/screen/route.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  TodoDatabase db = TodoDatabase();
  TodoDao todoDao = TodoDao();
  TaskDao taskDao = TaskDao();
  List<TodoModel> todos = [];

  @override
  void initState() {
    super.initState();
    updateTodos();
  }

  Future<void> updateTodos() async {
    todos = await todoDao.getTodos(db.database);
    Future.forEach(todos, (todo) async {
      todo.tasks = await taskDao.getTask(db.database, todo.id!);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: todos.length,
        itemBuilder: (BuildContext context, int index) {
          bool isTodoCompleted =
              !(todos[index].tasks.any((task) => !task.isCompleted));
          return InkWell(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(AppRoute.taskScreen, arguments: todos[index])
                  .then((value) {
                updateTodos();
              });
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            todos[index].name,
                            style: TextStyle(
                                decoration: isTodoCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none),
                          )),
                          PopupMenuButton<TodoOptions>(
                            onSelected: (value) async {
                              switch (value) {
                                case TodoOptions.edit:
                                  addOrUpdateTodo(oldTodo: todos[index]);
                                  break;
                                case TodoOptions.delete:
                                  await todoDao.deleteTodo(
                                      db.database, todos[index]);
                                  updateTodos();
                                  break;
                                case TodoOptions.markAsCompleted:
                                  await taskDao.markTaskAsCompleted(
                                      db.database, todos[index].id!);
                                  updateTodos();
                              }
                            },
                            itemBuilder: (context) {
                              return [
                                const PopupMenuItem(
                                  value: TodoOptions.edit,
                                  child: Text('Edit'),
                                ),
                                const PopupMenuItem(
                                  value: TodoOptions.delete,
                                  child: Text('Delete'),
                                ),
                                const PopupMenuItem(
                                  value: TodoOptions.markAsCompleted,
                                  child: Text('Mark as completed'),
                                ),
                              ];
                            },
                            child: const Icon(Icons.more_vert),
                          )
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: ListView.builder(
                          itemCount: todos[index].tasks.length,
                          itemBuilder: (_, taskIndex) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(todos[index].tasks[taskIndex].name),
                            );
                          }),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addOrUpdateTodo,
        child: const Icon(Icons.add),
      ),
    );
  }

  void addOrUpdateTodo({TodoModel? oldTodo}) {
    showDialog(
        context: context,
        builder: (context) {
          var todoController = TextEditingController(text: oldTodo?.name ?? '');
          return AlertDialog(
            title: Text('${oldTodo == null ? 'Add' : 'Update'} Todo'),
            content: TextField(
              controller: todoController,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Todo Name'),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () async {
                    String value = todoController.text;
                    if (value.isNotEmpty) {
                      if (oldTodo == null) {
                        await todoDao.addTodo(db.database, TodoModel(value));
                      } else {
                        oldTodo.name = value;
                        await todoDao.updateTodo(db.database, oldTodo);
                      }
                      await updateTodos();
                    }
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: Text(oldTodo == null ? 'Add' : 'Update'))
            ],
          );
        });
  }
}
