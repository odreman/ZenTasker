import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zen_tasker/app/model/task.dart';

class TaskModel extends ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;
  Object? _error;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  Object? get error => _error;

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }

  void updateTask(Task task) {
    var index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      notifyListeners();
    }
  }

  void toggleDone(Task task) {
    var index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index].isDone = !_tasks[index].isDone;
      notifyListeners();
    }
  }

  Future<void> loadTasks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getStringList('tasks') ?? [];
      _tasks = data.map((item) => Task.fromJson(json.decode(item))).toList();
    } catch (e) {
      _error = e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
