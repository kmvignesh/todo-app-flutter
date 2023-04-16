import 'dart:math';

import 'package:flutter/material.dart';
import 'package:todo/database/model/task_model.dart';
import 'package:todo/database/model/todo_model.dart';
import 'package:todo/database/task_dao.dart';
import 'package:todo/database/todo_database.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key, required this.todoModel}) : super(key: key);

  final TodoModel todoModel;

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  TodoDatabase db = TodoDatabase();
  TaskDao taskDao = TaskDao();
  List<TaskModel> tasks = [];
  late int todoId;

  @override
  void initState() {
    super.initState();
    todoId = widget.todoModel.id!;
    updateTasks();
  }

  Future<void> updateTasks() async {
    tasks = await taskDao.getTask(db.database, todoId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.todoModel.name),
      ),
      body: ReorderableListView.builder(
        itemBuilder: (_, index) {
          return Row(
            key: Key('task${tasks[index].id}'),
            children: [
              ReorderableDragStartListener(
                  index: index,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.drag_indicator),
                  )),
              Checkbox(
                  value: tasks[index].isCompleted,
                  onChanged: (newValue) {
                    if (newValue != null) {
                      setState(() {
                        tasks[index].isCompleted = newValue;
                      });
                      taskDao.updateTask(db.database, tasks[index]);
                    }
                  }),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tasks[index].name,
                      style: TextStyle(
                          decoration: tasks[index].isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none),
                    ),
                    Text(tasks[index].createdAt ?? ''),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  addOrUpdateTask(oldTask: tasks[index]);
                },
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () {
                  // We should show alert dialog before deleting. because its non-recoverable
                  taskDao.deleteTask(db.database, tasks[index].id!);
                  updateTasks();
                },
                icon: const Icon(Icons.delete),
              )
            ],
          );
        },
        itemCount: tasks.length,
        onReorder: (oldIndex, newIndex) {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final task = tasks.removeAt(oldIndex);
          tasks.insert(newIndex, task);
          int minIndex = min(oldIndex, newIndex);
          int maxIndex = max(oldIndex, newIndex);
          for (int i = minIndex; i <= maxIndex; i++) {
            TaskModel task = tasks[i];
            task.sequence = i + 1;
            taskDao.updateTask(db.database, task);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addOrUpdateTask,
        child: const Icon(Icons.add),
      ),
    );
  }

  void addOrUpdateTask({TaskModel? oldTask}) {
    showDialog(
        context: context,
        builder: (context) {
          var todoController = TextEditingController(text: oldTask?.name ?? '');
          return AlertDialog(
            title: Text('${oldTask == null ? 'Add' : 'Update'} Task'),
            content: TextField(
              controller: todoController,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Task Name'),
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
                      if (oldTask == null) {
                        await taskDao.addTask(db.database,
                            TaskModel(value, false, tasks.length + 1, todoId));
                      } else {
                        oldTask.name = value;
                        await taskDao.updateTask(db.database, oldTask);
                      }
                      await updateTasks();
                    }
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: Text(oldTask == null ? 'Add' : 'Update'))
            ],
          );
        });
  }
}
