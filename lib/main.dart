import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter binding is initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
              children: [
                Expanded(
                  child: Container(
                    color: Colors.blue[300], // Color for Schedule quadrant
                    child: const TodoListScreen(title: 'Schedule'),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.green[400], // Color for Do First quadrant
                    child: const TodoListScreen(title: 'Do First'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.red[100], // Color for Delegate quadrant
                    child: const TodoListScreen(title: "Don't Do"),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.yellow[200], // Color for Don't Do quadrant
                    child: const TodoListScreen(title: 'Delegate'),
                  ),
                ),
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      final snapshot = await _firestore.collection('tasks').doc(widget.title).get();
      if (snapshot.exists) {
        setState(() {
          _tasks = List<String>.from(snapshot.data()?['tasks'] ?? []);
        });
      }
    } catch (e) {
      print('Error loading tasks: $e');
    }
  }

  Future<void> _saveTasks() async {
    try {
      await _firestore.collection('tasks').doc(widget.title).set({
        'tasks': _tasks,
      });
    } catch (e) {
      print('Error saving tasks: $e');
    }
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