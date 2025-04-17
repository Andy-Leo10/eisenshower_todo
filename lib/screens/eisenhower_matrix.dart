import 'package:flutter/material.dart';
import 'todo_list_screen.dart';

class EisenhowerMatrix extends StatelessWidget {
  const EisenhowerMatrix({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.blue[300],
                    child: const TodoListScreen(title: 'Schedule'),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.green[400],
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
                    color: Colors.red[100],
                    child: const TodoListScreen(title: "Don't Do"),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.yellow[200],
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