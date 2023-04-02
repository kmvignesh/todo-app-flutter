import 'package:flutter/material.dart';
import 'package:todo/screen/splash_screen.dart';
import 'package:todo/screen/task_screen.dart';
import 'package:todo/screen/todo_screen.dart';

class AppRoute {
  static String splashScreen = 'splash';
  static String todoScreen = 'todo';
  static String taskScreen = 'task';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    if (settings.name == splashScreen) {
      return splashRoute();
    } else if (settings.name == todoScreen) {
      return MaterialPageRoute(
          builder: (BuildContext context) => const TodoScreen());
    } else if (settings.name == taskScreen) {
      return MaterialPageRoute(
          builder: (BuildContext context) => const TaskScreen());
    }
    return splashRoute();
  }

  static Route<dynamic> splashRoute() {
    return MaterialPageRoute(
        builder: (BuildContext context) => const SplashScreen());
  }
}
