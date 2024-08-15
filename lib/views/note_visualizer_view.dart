import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:fluttermarkdown/boxes.dart';
import 'package:fluttermarkdown/classes/note.dart';

class NoteVisualizerView extends StatelessWidget {
  const NoteVisualizerView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map;
    Note note = args['note'];
    dynamic key = args['key'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Nota'),
        actions: [
          IconButton(
            onPressed: () => deleteNote(key, context),
            icon: Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () => openEditPage(context, note, key),
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: ListView(
          children: [
            Card(
              child: ListTile(
                leading: Icon(Icons.title),
                title: Text(
                  note.title,
                  style: TextStyle(fontSize: 19),
                ),
              ),
            ),
            Card(
              child: note.body.isEmpty
                  ? Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: Text('Nenhum texto adicionado'),
                    )
                  : ListTile(
                      title: MarkdownBody(
                        data: note.body,
                        selectable: true,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void deleteNote(key, BuildContext context) {
    boxNotes.delete(key);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sua nota foi deletada!')),
    );

    Navigator.pop(context);
  }

  void openEditPage(BuildContext context, Note note, key) {
    Navigator.pushNamed(
      context,
      '/edit',
      arguments: {'note': note, 'key': key},
    );
  }
}
