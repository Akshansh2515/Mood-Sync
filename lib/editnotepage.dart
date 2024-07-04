import 'package:flutter/material.dart';
import 'EmotionDetector.dart';
import 'note.dart';
import 'package:url_launcher/url_launcher.dart';

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
  String? _searchQuery;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _emotions = widget.note!.emotions;
      _fetchSearchQuery();
    }
  }

  void _saveNote() {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text;
      final content = _contentController.text;
      final emotions = emotionDetector.detectEmotions(content);

      final note = Note(
        id: widget.note?.id,
        title: title,
        content: content,
        timestamp: widget.note?.timestamp ?? DateTime.now(),
        emotions: emotions,
      );

      widget.onSave(note);
      Navigator.pop(context, note);
    }
  }

  void _fetchSearchQuery() {
    if (_emotions != null && _emotions!.isNotEmpty) {
      final dominantMood =
          _emotions!.entries.reduce((a, b) => a.value > b.value ? a : b).key;
      final query = 'Songs for mood $dominantMood';
      setState(() {
        _searchQuery = query;
      });
    }
  }

  Future<void> _openYouTube() async {
    final searchQuery = _searchQuery;
    if (searchQuery != null) {
      final query = Uri.encodeComponent(searchQuery);
      final url = 'https://www.youtube.com/results?search_query=$query';
      final uri = Uri.parse(url);
      try {
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          await _showErrorSnackBar('Could not open YouTube.');
        }
      } catch (e) {
        await _showErrorSnackBar('Could not open YouTube: ${e.toString()}');
      }
    } else {
      await _showErrorSnackBar('No search query available');
    }
  }

  Future<void> _showErrorSnackBar(String message) async {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
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
                  onChanged: (value) {
                    final emotions = emotionDetector.detectEmotions(value);
                    setState(() {
                      _emotions = emotions;
                    });
                    _fetchSearchQuery();
                  },
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
                if (_searchQuery != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: _openYouTube,
                      child: const Text('Recommend Songs'),
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
