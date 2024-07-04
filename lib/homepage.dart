import 'package:flutter/material.dart';
import 'note.dart';
import 'editNotePage.dart';
import 'noteStorage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NoteStorage _noteStorage = NoteStorage();
  List<Note> _notes = [];

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
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];
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
                color: index % 2 == 0 ? Colors.blue[100] : Colors.green[100],
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
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
