import 'package:flutter/material.dart';
import 'package:fluttermarkdown/views/edit_note_view.dart';
import 'package:fluttermarkdown/views/list_notes_view.dart';
import 'package:fluttermarkdown/views/note_visualizer_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => ListNotesView(),
        '/vizualizer': (context) => NoteVisualizerView(),
        '/edit': (context) => EditNoteView(),
      },
    );
  }
}
