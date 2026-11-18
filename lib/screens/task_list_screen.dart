import 'package:flutter/material.dart';
import '../models/task.dart';
import 'add_task_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<Task> _tasks = [];

  int get _completedCount => _tasks.where((task) => task.isCompleted).length;

  Future<void> _navigateToAddTask() async {
    final Task? newTask = await Navigator.push<Task>(
      context,
      MaterialPageRoute(builder: (context) => const AddTaskScreen()),
    );

    // Se l'utente ha confermato (non ha rinunciato)
    if (newTask != null) {
      setState(() {
        _tasks.add(newTask);
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Attività "${newTask.title}" aggiunta.'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _toggleTaskStatus(Task task) {
    setState(() {
      task.isCompleted = !task.isCompleted;
    });
  }

  Future<void> _confirmDeleteTask(Task task) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Elimina attività'),
        content: Text('Vuoi davvero eliminare "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annulla'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Elimina'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _tasks.removeWhere((item) => item.id == task.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Le mie attività'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Barra del conteggio sempre visibile (S2)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Completate',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                Text(
                  '$_completedCount / ${_tasks.length}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),

          // Elenco attività oppure stato vuoto (S2 variante)
          Expanded(
            child: _tasks.isEmpty
                ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.checklist, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Nessuna attività presente',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Premi il pulsante + in basso a destra per aggiungere la tua prima attività.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
                : ListView.separated(
              itemCount: _tasks.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return ListTile(
                  leading: Checkbox(
                    value: task.isCompleted,
                    onChanged: (_) => _toggleTaskStatus(task),
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                      color: task.isCompleted ? Colors.grey : null,
                      fontWeight: task.isImportant
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    task.isCompleted ? 'Completata' : 'Da fare',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (task.isImportant)
                        const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Tooltip(
                            message: 'Importante',
                            child: Icon(Icons.star, color: Colors.amber),
                          ),
                        ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        tooltip: 'Elimina',
                        onPressed: () => _confirmDeleteTask(task),
                      ),
                    ],
                  ),
                  onTap: () => _toggleTaskStatus(task),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTask,
        tooltip: 'Aggiungi attività',
        child: const Icon(Icons.add),
      ),
    );
  }
}
