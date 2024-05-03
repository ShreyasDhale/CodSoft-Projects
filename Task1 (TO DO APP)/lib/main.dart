import 'package:flutter/material.dart';
import 'package:to_do_app/Config/NotificationHelper.dart';
import 'package:to_do_app/Config/SQLHelper.dart';
import 'package:to_do_app/Screens/SplashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationHelper.initilize();
  await SQLHelper.db();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
