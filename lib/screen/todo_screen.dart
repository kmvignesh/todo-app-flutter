import 'package:flutter/material.dart';
import 'package:todo/common/enums.dart';
import 'package:todo/database/model/todo_model.dart';
import 'package:todo/database/todo_dao.dart';
import 'package:todo/database/todo_database.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  TodoDatabase db = TodoDatabase();
  TodoDao todoDao = TodoDao();
  List<TodoModel> todos = [];

  @override
  void initState() {
    super.initState();
    updateTodos();
  }

  Future<void> updateTodos() async {
    todos = await todoDao.getTodos(db.database);
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
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(child: Text(todos[index].name)),
                  PopupMenuButton<TodoOptions>(
                    onSelected: (value) async {
                      if (value == TodoOptions.edit) {
                        addOrUpdateTodo(oldTodo: todos[index]);
                      } else if (value == TodoOptions.delete) {
                        await todoDao.deleteTodo(db.database, todos[index]);
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
                      ];
                    },
                    child: const Icon(Icons.more_vert),
                  )
                ],
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
