import 'package:flutter/material.dart';

import '../models/task.dart';
import 'edit_task_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Title
            Text(
              task.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Task Description
            const Text(
              'Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(
              task.description.isNotEmpty
                  ? task.description
                  : 'No description provided.',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Task Due Date
            Text(
              'Due Date: ${task.dueDate.toLocal().toString().split(' ')[0]}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const Spacer(),

            // Edit Task Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditTaskScreen(task: task),
                  ),
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit Task'),
            ),
          ],
        ),
      ),
    );
  }
}
