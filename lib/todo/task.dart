import 'package:uuid/uuid.dart';

class Task {
  final String title;
  final String text;
  bool isDone;
  final String id;

  Task({
    required this.isDone,
    required this.title,
    required this.text,
  }) : id = const Uuid().v4();
}
