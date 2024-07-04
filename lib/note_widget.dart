import 'package:flutter/material.dart';
import 'note.dart';

class NoteWidget extends StatelessWidget {
  final Note note;

  const NoteWidget({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.lightBlue[100],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            note.title,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(note.content),
          const SizedBox(height: 8.0),
          ...[
            const Divider(),
            const Text(
              'Emotions:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            for (var emotion in note.emotions.entries)
              Text('${emotion.key}: ${emotion.value.toStringAsFixed(2)}%'),
          ],
        ],
      ),
    );
  }
}
