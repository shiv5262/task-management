import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task.dart';
import '../viewmodels/task_viewmodel.dart';
import '../widgets/custom_button.dart';

class EditTaskScreen extends ConsumerStatefulWidget {
  final Task? task;

  const EditTaskScreen({super.key, this.task});

  @override
  ConsumerState<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends ConsumerState<EditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _dueDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.task?.description ?? '');
    _dueDate =
        widget.task?.dueDate ?? DateTime.now().add(const Duration(minutes: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(widget.task == null ? 'Add Task' : 'Edit Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                    'Due Date: ${_dueDate.toLocal().toString().split(' ')[0]}'),
                const Spacer(),
                TextButton(
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _dueDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() => _dueDate = pickedDate);
                    }
                  },
                  child: const Text('Select Date'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomButton(
              label: widget.task == null ? 'Add Task' : 'Update Task',
              onPressed: () {
                if (_dueDate.isBefore(DateTime.now())) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Due date must be in the future!'),
                    ),
                  );
                  return;
                }

                final task = Task(
                  id: widget.task?.id,
                  title: _titleController.text,
                  description: _descriptionController.text,
                  dueDate: _dueDate,
                  isCompleted: widget.task?.isCompleted ?? false,
                );

                if (widget.task == null) {
                  ref.read(taskProvider.notifier).addTask(task);
                } else {
                  ref.read(taskProvider.notifier).updateTask(task);
                }
                Navigator.pop(context);
              },
              backgroundColor: Theme.of(context).primaryColor,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
