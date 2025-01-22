import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task.dart';
import '../viewmodels/task_viewmodel.dart';
import '../widgets/responsive_widget.dart';
import '../widgets/task_item.dart';
import 'edit_task_screen.dart';
import 'settings_screen.dart';
import 'task_detail_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _searchQuery = '';
  Task? _selectedTask;

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskProvider).where((task) {
      return task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          task.description.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: ResponsiveLayout(
        mobileBuilder: (context) => TaskListView(
          tasks: tasks,
          onTaskSelected: (task) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetailScreen(task: task),
              ),
            );
          },
        ),
        tabletBuilder: (context) => Row(
          children: [
            Expanded(
              flex: 1,
              child: TaskListView(
                tasks: tasks,
                onTaskSelected: (task) {
                  setState(() {
                    _selectedTask = task;
                  });
                },
                selectedTask: _selectedTask,
              ),
            ),
            Expanded(
              flex: 1,
              child: _selectedTask == null
                  ? const Center(
                      child: Text(
                        'Select a task to view details',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : TaskDetailTab(task: _selectedTask!),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EditTaskScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TaskListView extends StatelessWidget {
  final List<Task> tasks;
  final ValueChanged<Task> onTaskSelected;
  final Task? selectedTask;

  const TaskListView({
    super.key,
    required this.tasks,
    required this.onTaskSelected,
    this.selectedTask,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const Center(child: Text('No tasks available'));
    }

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        final isSelected = task == selectedTask;

        return GestureDetector(
          onTap: () => onTaskSelected(task),
          child: Container(
            color: isSelected ? Colors.blue.shade50 : Colors.transparent,
            child: TaskItem(task: task),
          ),
        );
      },
    );
  }
}

class TaskDetailTab extends StatelessWidget {
  final Task task;

  const TaskDetailTab({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Task Title
          Text(
            task.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

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
        ],
      ),
    );
  }
}
