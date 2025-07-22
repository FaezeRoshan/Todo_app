import 'package:flutter/material.dart';

import 'task.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> taskList = [];

  List<Task> get tasks => taskList;

  void create({required Task task}) {
    taskList.add(task);
    notifyListeners();
  }

  void update({required String id}) {
    final list = taskList.where((element) => element.id == id).toList();
    list.first.isDone = !list.first.isDone;
    notifyListeners();
  }

  void delete({required String id}) {
    taskList.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
