import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class NoteVisualizerView extends StatelessWidget {
  const NoteVisualizerView({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final title = args['title']!;
    final body = args['body']!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Nota'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(
              context,
              '/edit',
              arguments: {
                'title': title,
                'body': body,
              },
            ),
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
                title: Text(title),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.text_snippet),
                title: MarkdownBody(data: body),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
