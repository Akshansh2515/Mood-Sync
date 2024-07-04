import 'package:flutter/material.dart';
import 'EmotionDetector.dart';
import 'note.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;
  final Function(Note) onSave;

  const AddEditNotePage({super.key, this.note, required this.onSave});

  @override
  _AddEditNotePageState createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final EmotionDetector emotionDetector = EmotionDetector();

  Map<String, double>? _emotions;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _emotions = widget.note!.emotions;
    }
  }

  void _saveNote() {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text;
      final content = _contentController.text;
      final emotions = emotionDetector.detectEmotions(content);

      final note = Note(
        id: widget.note?.id ?? DateTime.now().millisecondsSinceEpoch,
        title: title,
        content: content,
        timestamp: widget.note?.timestamp ?? DateTime.now(),
        emotions: emotions,
      );

      widget.onSave(note);
      Navigator.pop(context, note);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Add Note' : 'Edit Note'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(labelText: 'Content'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some content';
                    }
                    return null;
                  },
                  maxLines: 10,
                ),
                if (_emotions != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _emotions!.entries
                          .map((entry) => Text(
                              '${entry.key}: ${entry.value.toStringAsFixed(2)}%'))
                          .toList(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveNote,
        child: const Icon(Icons.save),
      ),
    );
  }
}
