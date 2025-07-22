import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'todo/task_provider.dart';
import 'todo/todo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: MaterialApp(
        debugShowMaterialGrid: false,
        theme: ThemeData(primarySwatch: Colors.grey),
        debugShowCheckedModeBanner: false,
        home: const Todo(),
      ),
    );
  }
}
