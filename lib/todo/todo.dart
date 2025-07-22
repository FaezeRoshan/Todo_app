import 'package:flutter/material.dart';
import 'task.dart';
import 'package:provider/provider.dart';
import 'task_provider.dart';

class Todo extends StatefulWidget {
  const Todo({super.key});

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  bool checkbox = false;
  late final TextEditingController _titleControler;
  late final TextEditingController _textControler;

  @override
  void initState() {
    _titleControler = TextEditingController();
    _textControler = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _titleControler.dispose();
    _textControler.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final watchProvider = context.watch<TaskProvider>();
    final provider = context.read<TaskProvider>();
    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color(0xffececec),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final add = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  "Add Task",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.green.shade800),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _titleControler,
                      decoration: InputDecoration(
                          label: Text(
                            "Title",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.green.shade800),
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.green.shade300))),
                      cursorColor: Colors.green.shade800,
                      style: TextStyle(color: Colors.green.shade600),
                    ),
                    TextField(
                      controller: _textControler,
                      decoration: InputDecoration(
                          label: Text(
                            "Text",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.green.shade800),
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.green.shade300))),
                      cursorColor: Colors.green.shade800,
                      style:
                          TextStyle(fontSize: 15, color: Colors.green.shade600),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: Text(
                        "Add",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                      ))
                ],
              );
            },
          );
          if (add && add != null) {
            final task = Task(
              isDone: false,
              title: _titleControler.text,
              text: _textControler.text,
            );
            provider.create(task: task);
          }
          _textControler.clear();
          _titleControler.clear();
        },
        backgroundColor: Colors.green.shade800,
        child: const Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
        elevation: 8,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const Header(),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 250,
              child: ListView.builder(
                itemCount: watchProvider.tasks.length,
                itemBuilder: (context, index) {
                  final task = watchProvider.tasks[index];
                  return Dismissible(
                    key: Key(task.id),
                    background: const Card(
                      color: Colors.red,
                      child: Icon(
                        Icons.delete,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      provider.delete(id: task.id);
                    },
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              "Delete Task",
                              style: TextStyle(
                                  color: Colors.green.shade800,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20),
                            ),
                            content: Text(
                              "Are you sure?",
                              style: TextStyle(
                                  color: Colors.green.shade800, fontSize: 18),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                  child: Text(
                                    "yes",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.green.shade800),
                                  )),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                  child: Text("no",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.green.shade800)))
                            ],
                          );
                        },
                      );
                    },
                    child: Card(
                      elevation: 7,
                      child: ListTile(
                        title: Text(
                          task.title,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              color: Colors.green.shade800),
                        ),
                        subtitle: Text(task.text,
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey.shade900)),
                        leading: Checkbox(
                          activeColor: Colors.green.shade800,
                          value: task.isDone,
                          onChanged: (value) {
                            provider.update(id: task.id);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final watchProvider = context.watch<TaskProvider>();
    return SizedBox(
      height: 250,
      child: Stack(
        children: [
          Positioned(
            child: Container(
              height: 200,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.green.shade800,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                      bottomRight: Radius.circular(100))),
              child: const Text(
                "Let's do!",
                style: TextStyle(
                    fontSize: 40,
                    fontFamily: "Josefin",
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          Positioned(
              top: 150,
              left: (screenWidth - 140) / 2,
              child: SizedBox(
                height: 90,
                width: 140,
                child: Card(
                  elevation: 10,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        "Task",
                        style: TextStyle(
                            color: Colors.green.shade800,
                            fontFamily: "SourceSansPro",
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        watchProvider.tasks.length.toString(),
                        style: TextStyle(
                            color: Colors.green.shade800,
                            fontFamily: "SourceSansPro",
                            fontSize: 25),
                      )
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
