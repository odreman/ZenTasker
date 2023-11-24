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

  void reorderTasks(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final Task task = tasks.removeAt(oldIndex);
    tasks.insert(newIndex, task);
    _saveTasks();
    notifyListeners();
  }

  void addTask(Task task) async {
    _tasks.add(task);
    await _saveTasks();
    notifyListeners();
  }

  void deleteTask(Task task) async {
    _tasks.remove(task);
    await _saveTasks();
    notifyListeners();
  }

  void updateTask(Task task) async {
    var index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      await _saveTasks();
      notifyListeners();
    }
  }

  void toggleDone(Task task) async {
    var index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index].isDone = !_tasks[index].isDone;
      await _saveTasks();
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

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _tasks.map((task) => json.encode(task.toJson())).toList();
    await prefs.setStringList('tasks', data);
  }
}
