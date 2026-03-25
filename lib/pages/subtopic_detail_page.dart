import 'package:flutter/material.dart';

class SubtopicDetailPage extends StatelessWidget {
  final String subtopicTitle;

  const SubtopicDetailPage({super.key, required this.subtopicTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(subtopicTitle)),
      body: Center(
        child: Text(
          'Lesson for $subtopicTitle coming soon!',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
