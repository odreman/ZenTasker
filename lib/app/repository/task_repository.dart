import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:zen_tasker/app/model/task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zen_tasker/services/notification_services.dart';

class TaskRepository {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  TaskRepository(this.flutterLocalNotificationsPlugin);

  Future<bool> addTask(Task task) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonTasks = prefs.getStringList('tasks') ?? [];
    jsonTasks.add(jsonEncode(task.toJson()));
    return prefs.setStringList('tasks', jsonTasks);
  }

  Future<List<Task>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonTasks = prefs.getStringList('tasks') ?? [];

    return jsonTasks
        .map((jsonTask) => Task.fromJson(jsonDecode(jsonTask)))
        .toList();
  }

  Future<bool> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonTasks = tasks.map((e) => jsonEncode(e.toJson())).toList();
    return prefs.setStringList('tasks', jsonTasks);
  }

  Future<bool> updateTask(Task task) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonTasks = prefs.getStringList('tasks') ?? [];
    final taskIndex = jsonTasks.indexWhere(
        (jsonTask) => Task.fromJson(jsonDecode(jsonTask)).id == task.id);
    if (taskIndex != -1) {
      jsonTasks[taskIndex] = jsonEncode(task.toJson());
      return prefs.setStringList('tasks', jsonTasks);
    }
    return false;
  }
}
