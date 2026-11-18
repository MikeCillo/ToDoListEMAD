import 'package:flutter/material.dart';
import '../models/task.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  bool _isImportant = false;
  String? _titleError;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _saveTask() {
    final trimmedTitle = _titleController.text.trim();

    if (trimmedTitle.isEmpty) {
      setState(() {
        _titleError = 'Il titolo dell\'attività è obbligatorio.';
      });
      return;
    }

    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: trimmedTitle,
      isImportant: _isImportant,
    );

    Navigator.pop(context, newTask);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuova attività'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Titolo attività *',
                hintText: 'Es. Studiare per l\'esame di Flutter',
                border: const OutlineInputBorder(),
                errorText: _titleError,
              ),
              onChanged: (value) {
                // L'errore scompare appena l'utente corregge il titolo
                if (_titleError != null && value.trim().isNotEmpty) {
                  setState(() {
                    _titleError = null;
                  });
                }
              },
              onSubmitted: (_) => _saveTask(),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Attività importante'),
              subtitle: const Text('Evidenzia questa attività nell\'elenco'),
              secondary: Icon(
                _isImportant ? Icons.star : Icons.star_border,
                color: _isImportant ? Colors.amber : null,
              ),
              value: _isImportant,
              onChanged: (value) {
                setState(() {
                  _isImportant = value;
                });
              },
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _saveTask,
              icon: const Icon(Icons.check),
              label: const Text('Salva attività'),
            ),
          ],
        ),
      ),
    );
  }
}
