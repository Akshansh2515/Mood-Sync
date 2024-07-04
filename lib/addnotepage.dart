import 'package:flutter/material.dart';
import 'note.dart';

class AddNotePage extends StatefulWidget {
  final Function(Note) onAddNote;

  const AddNotePage({super.key, required this.onAddNote});

  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Content'),
              maxLines: 10,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                final note = Note(
                  title: _titleController.text,
                  content: _contentController.text,
                  timestamp: DateTime.now(),
                  emotions: {},
                );
                widget.onAddNote(note);
                Navigator.pop(context);
              },
              child: const Text('Add Note'),
            ),
          ],
        ),
      ),
    );
  }
}
