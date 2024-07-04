import 'package:flutter/material.dart';
import 'homepage.dart';

void main() {
  runApp(const MoodSync());
}

class MoodSync extends StatelessWidget {
  const MoodSync({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoodSync',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false, // This line removes the debug banner
    );
  }
}
