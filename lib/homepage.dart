import 'package:flutter/material.dart';
import 'note.dart';
import 'editNotePage.dart';
import 'noteStorage.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NoteStorage _noteStorage = NoteStorage();
  List<Note> _notes = [];
  final Random _random = Random(); // Random number generator

  // List of colors to choose from
  final List<Color> _colors = [
    Colors.lightBlueAccent.shade100, // Light Blue Accent
    const Color(0xffeee1ff), // Lavender
    Colors.orange.shade100, // Light Orange
    Colors.blue.shade100, // Light Blue (Currently Used Color)
    const Color(0xff77dd77), // Pastel Green
    const Color(0xffaec6cf), // Pastel Blue
    const Color(0xffffb3e6), // Pastel Pink
    const Color(0xffe3bced), // Light Lavender
    const Color(0xffffdab9), // Soft Peach
    const Color(0xff98ff98), // Mint Green
    const Color(0xfff08080),
  ];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final notes = await _noteStorage.readNotes();
    setState(() {
      _notes = notes;
    });
  }

  Future<void> _addOrUpdateNote(Note note) async {
    final index = _notes.indexWhere((n) => n.id == note.id);
    setState(() {
      if (index >= 0) {
        _notes[index] = note;
      } else {
        _notes.add(note);
      }
    });
    await _noteStorage.writeNotes(_notes);
  }

  Future<void> _deleteNoteAt(int index) async {
    setState(() {
      _notes.removeAt(index);
    });
    await _noteStorage.writeNotes(_notes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        backgroundColor: Colors
            .yellow.shade200, // Light yellow background color for the AppBar
      ),
      backgroundColor: Colors.yellow
          .shade200, // Very light yellow background color for the whole screen
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];
          final color = _colors[_random
              .nextInt(_colors.length)]; // Select a random color from the list

          return GestureDetector(
            onTap: () async {
              final updatedNote = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditNotePage(
                    note: note,
                    onSave: _addOrUpdateNote,
                  ),
                ),
              );
              if (updatedNote != null) {
                _addOrUpdateNote(updatedNote);
              }
            },
            onLongPress: () async {
              final shouldDelete = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Note'),
                  content:
                      const Text('Are you sure you want to delete this note?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
              if (shouldDelete ?? false) {
                _deleteNoteAt(index);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: color, // Assigning a random color for each note
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    note.content,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newNote = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditNotePage(
                onSave: _addOrUpdateNote,
              ),
            ),
          );
          if (newNote != null) {
            _addOrUpdateNote(newNote);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
