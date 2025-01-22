import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../main.dart';
import '../models/task.dart';
import '../services/database_service.dart';

class TaskViewModel extends StateNotifier<List<Task>> {
  TaskViewModel() : super([]);

  final _dbService = DatabaseService();

  Future<void> loadTasks() async {
    state = await _dbService.getTasks();
  }

  Future<void> addTask(Task task) async {
    await _dbService.addTask(task);
    await scheduleNotification(task);
    await loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await _dbService.updateTask(task);
    await scheduleNotification(task);
    await loadTasks();
  }

  Future<void> deleteTask(int id) async {
    await _dbService.deleteTask(id);
    await flutterLocalNotificationsPlugin.cancel(id);
    await loadTasks();
  }

  Future<void> toggleTaskStatus(Task task) async {
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
      isCompleted: !task.isCompleted,
    );

    // Cancel notification if the task is being marked as completed
    if (updatedTask.isCompleted) {
      await flutterLocalNotificationsPlugin.cancel(updatedTask.id!);
    } else if (updatedTask.dueDate.isAfter(DateTime.now())) {
      // Schedule notification only if the due date is in the future
      await scheduleNotification(updatedTask);
    }

    await updateTask(updatedTask);
  }

  Future<void> searchTasks(String query) async {
    final allTasks = await _dbService.getTasks();
    state = allTasks.where((task) {
      return task.title.toLowerCase().contains(query.toLowerCase()) ||
          task.description.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}

Future<void> scheduleNotification(Task task) async {
  tz.initializeTimeZones(); // Ensure time zones are initialized

  // Check if the due date is in the future
  if (task.dueDate.isBefore(DateTime.now())) {
    return; // Do not schedule a notification if the date is in the past
  }

  const androidDetails = AndroidNotificationDetails(
    'task_reminder_channel',
    'Task Reminders',
    channelDescription: 'Reminders for your tasks',
    importance: Importance.max,
    priority: Priority.high,
  );

  const notificationDetails = NotificationDetails(
    android: androidDetails,
    iOS: DarwinNotificationDetails(),
  );

  await flutterLocalNotificationsPlugin.zonedSchedule(
    task.id ?? 0, // Unique ID for the task
    'Task Reminder',
    'Don\'t forget: ${task.title}', // Notification body
    tz.TZDateTime.from(task.dueDate, tz.local), // Convert dueDate to TZDateTime
    notificationDetails,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  );
}

final taskProvider = StateNotifierProvider<TaskViewModel, List<Task>>((ref) {
  return TaskViewModel()..loadTasks();
});
