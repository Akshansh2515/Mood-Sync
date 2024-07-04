import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'note.dart';

class NoteStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/notes.json');
  }

  Future<List<Note>> readNotes() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      // Decode JSON to List<Note>
      final List<dynamic> jsonList = jsonDecode(contents);
      return jsonList.map((json) => Note.fromJson(json)).toList();
    } catch (e) {
      // If encountering an error, return an empty list
      return [];
    }
  }

  Future<File> writeNotes(List<Note> notes) async {
    final file = await _localFile;

    // Encode List<Note> to JSON
    final String jsonString =
        jsonEncode(notes.map((note) => note.toJson()).toList());

    // Write the file
    return file.writeAsString(jsonString);
  }
}
