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
        id: widget.note?.id ??
            DateTime.now().toString(), // Generate a new unique ID for new notes
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
        backgroundColor: Colors
            .yellow.shade300, // More yellowish background color for the AppBar
      ),
      backgroundColor: Colors.yellow
          .shade100, // Light yellow background color for the whole screen
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch, // Ensure elements take full width
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: 'Title',
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w700, // Bold weight for the title
                      fontSize: 32, // Larger font size for the title
                      color: Colors.black, // Color for the title text
                    ),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 12.0), // Padding for the title
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                Container(
                  padding: const EdgeInsets.all(16.0), // Increased padding
                  decoration: BoxDecoration(
                    color: const Color(
                        0xffeee1ff), // Dark color for the content box
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextFormField(
                    controller: _contentController,
                    decoration: const InputDecoration(
                      hintText: 'Content',
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some content';
                      }
                      return null;
                    },
                    maxLines: 10, // Increased number of lines
                    style: const TextStyle(
                      color: Colors.black, // White text color for content
                      fontSize: 18, // Font size for the content
                      fontWeight:
                          FontWeight.w400, // Regular weight for the content
                    ),
                    onChanged: (value) {
                      final emotions = emotionDetector.detectEmotions(value);
                      setState(() {
                        _emotions = emotions;
                      });
                      _fetchSearchQuery();
                    },
                  ),
                ),
                if (_emotions != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.orange
                            .shade100, // Background color for the sentiment analysis box
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sentimental Analysis',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          ..._emotions!.entries.map((entry) => Text(
                              '${entry.key}: ${entry.value.toStringAsFixed(2)}%',
                              style: const TextStyle(
                                color: Colors.black, // Text color for emotions
                                fontSize: 16, // Font size for emotions
                                fontWeight: FontWeight
                                    .w400, // Regular weight for emotions
                              )))
                        ],
                      ),
                    ),
                  ),
                if (_searchQuery != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: _openYouTube,
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.yellow
                            .shade300, // Yellow background for the button
                        foregroundColor:
                            Colors.black, // Black text color for the button
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        elevation: 4.0, // Add shadow for the button
                      ),
                      child: const Text(
                        'Recommend Songs',
                        style: TextStyle(
                          fontSize: 18, // Font size for the button text
                          fontWeight: FontWeight
                              .w600, // Semi-bold weight for the button text
                        ),
                      ),
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
