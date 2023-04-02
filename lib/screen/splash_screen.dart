import 'package:flutter/material.dart';
import 'package:todo/database/todo_database.dart';
import 'package:todo/screen/route.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double sizeStart = 0, sizeEnd = 200;
  int duration = 1000;
  double opacityStart = 1, opacityEnd = 1;

  @override
  void initState() {
    super.initState();
    animate();
  }

  void animate() {
    Future.delayed(const Duration(seconds: 2)).then((value) async {
      TodoDatabase database = TodoDatabase();
      await database.initialise();
      setState(() {
        opacityEnd = 0;
        sizeEnd = 400;
        duration = 200;
      });
      Future.delayed(Duration(milliseconds: duration)).then((value) {
        Navigator.pushReplacementNamed(context, AppRoute.todoScreen);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: sizeStart, end: sizeEnd),
          duration: Duration(milliseconds: duration),
          builder: (BuildContext context, double size, Widget? child) {
            return TweenAnimationBuilder(
              tween: Tween<double>(begin: opacityStart, end: opacityEnd),
              duration: Duration(milliseconds: duration),
              builder: (BuildContext context, double opacity, Widget? child) {
                return Opacity(
                  opacity: opacity,
                  child: Image.asset(
                    'asset/image/todo_app_icon.png',
                    width: size,
                    height: size,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
