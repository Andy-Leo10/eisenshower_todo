import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> loadTasks(String title) async {
    try {
      final snapshot = await _firestore.collection('tasks').doc(title).get();
      if (snapshot.exists) {
        return List<String>.from(snapshot.data()?['tasks'] ?? []);
      }
    } catch (e) {
      print('Error loading tasks: $e');
    }
    return [];
  }

  Future<void> saveTasks(String title, List<String> tasks) async {
    try {
      await _firestore.collection('tasks').doc(title).set({
        'tasks': tasks,
      });
    } catch (e) {
      print('Error saving tasks: $e');
    }
  }
}