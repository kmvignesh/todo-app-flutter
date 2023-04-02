import 'package:flutter/material.dart';
import 'package:todo/screen/route.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.green),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.green, foregroundColor: Colors.white),
        useMaterial3: true),
    initialRoute: AppRoute.splashScreen,
    onGenerateRoute: AppRoute.onGenerateRoute,
    debugShowCheckedModeBanner: false,
  ));
}
