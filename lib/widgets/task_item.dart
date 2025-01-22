import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task.dart';
import '../viewmodels/task_viewmodel.dart';
import '../views/edit_task_screen.dart';

class TaskItem extends ConsumerWidget {
  final Task task;

  const TaskItem({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        isThreeLine: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (value) {
            ref.read(taskProvider.notifier).toggleTaskStatus(task);
          },
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.description,
              style: const TextStyle(fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              'Due: ${task.dueDate.toLocal().toString().split(' ')[0]}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditTaskScreen(task: task),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                ref.read(taskProvider.notifier).deleteTask(task.id!);
              },
            ),
          ],
        ),
      ),
    );
  }
}
