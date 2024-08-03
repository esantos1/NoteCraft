import 'package:flutter/material.dart';
import 'package:fluttermarkdown/controllers/list_notes_controller.dart';

class ListNotesView extends StatelessWidget {
  ListNotesView({super.key});

  final controller = ListNotesController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Notas'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/edit'),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: controller.model.notas.length,
        itemBuilder: (context, index) {
          int key = controller.model.notas.keys.elementAt(index);
          String title = controller.model.notas[key]!['title']!;
          String body = controller.model.notas[key]!['body']!;

          return Card(
            child: ListTile(
              leading: Icon(Icons.note),
              title: Text(title),
              onTap: () => Navigator.pushNamed(
                context,
                '/vizualizer',
                arguments: {
                  'title': title,
                  'body': body,
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void openNote() {}
}
