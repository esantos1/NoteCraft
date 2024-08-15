import 'package:flutter/material.dart';
import 'package:fluttermarkdown/boxes.dart';
import 'package:fluttermarkdown/classes/note.dart';
import 'package:fluttermarkdown/views/edit_note_view.dart';
import 'package:fluttermarkdown/views/list_notes_view.dart';
import 'package:fluttermarkdown/views/note_visualizer_view.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  boxNotes = await Hive.openBox<Note>('noteBox');

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
