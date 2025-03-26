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
      body: Column(
        children: [
          const SizedBox(height: 16), // Add padding or block above all quadrants
          Expanded(
            child: Row(
              children: const [
                Expanded(child: TodoListScreen(title: 'Schedule')),
                Expanded(child: TodoListScreen(title: 'Do First')),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: const [
                Expanded(child: TodoListScreen(title: 'Delegate')),
                Expanded(child: TodoListScreen(title: 'Don\'t Do')),
              ],
            ),
          ),
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
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: '${widget.title}',
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
        Expanded(
          child: SingleChildScrollView(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
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
        ),
      ],
    );
  }
}