import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: EisenhowerMatrix(),
    );
  }
}

class EisenhowerMatrix extends StatelessWidget {
  const EisenhowerMatrix({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eisenhower Matrix'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: const [
          TodoListScreen(title: 'Important & Urgent'),
          TodoListScreen(title: 'Important & Not Urgent'),
          TodoListScreen(title: 'Not Important & Urgent'),
          TodoListScreen(title: 'Not Important & Not Urgent'),
        ],
      ),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  final String title;

  const TodoListScreen({required this.title, super.key});

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<String> _tasks = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksString = prefs.getString(widget.title);
    if (tasksString != null) {
      setState(() {
        _tasks = List<String>.from(json.decode(tasksString));
      });
    }
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(widget.title, json.encode(_tasks));
  }

  void _addTask(String task) {
    setState(() {
      _tasks.add(task);
    });
    _saveTasks();
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
    _saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'New Task',
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    _addTask(_controller.text);
                    _controller.clear();
                  }
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _tasks.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_tasks[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.check_box),
                  onPressed: () {
                    _removeTask(index);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}