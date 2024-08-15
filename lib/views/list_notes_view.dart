import 'package:flutter/material.dart';
import 'package:fluttermarkdown/boxes.dart';
import 'package:fluttermarkdown/classes/note.dart';
import 'package:fluttermarkdown/controllers/list_notes_controller.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ListNotesView extends StatefulWidget {
  const ListNotesView({super.key});

  @override
  State<ListNotesView> createState() => _ListNotesViewState();
}

class _ListNotesViewState extends State<ListNotesView> {
  final controller = ListNotesController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _appBar(),
        body: ValueListenableBuilder(
            valueListenable: boxNotes.listenable(),
            builder: (context, box, _) {
              if (box.isEmpty) {
                return Center(
                  child: Text('Você não criou nenhuma nota ainda!'),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: boxNotes.length,
                itemBuilder: (context, index) {
                  final key = box.keyAt(index);
                  Note item = box.getAt(index);

                  return _buildItems(item, context, key);
                },
              );
            }),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.pushNamed(context, '/edit'),
          label: Text('Criar nota'),
          icon: Icon(Icons.add),
        ),
      );

  AppBar _appBar() => controller.model.selectedNotesKeys.isNotEmpty
      ? AppBar(
          leading: IconButton(
            onPressed: addOrRemoveAllToSelectedItemsList,
            icon: Icon(
              controller.model.selectedNotesKeys.length == boxNotes.keys.length
                  ? Icons.check_circle
                  : Icons.circle_outlined,
            ),
          ),
          title: Text(
            '${controller.model.selectedNotesKeys.length} notas selecionadas',
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  boxNotes.deleteAll(controller.model.selectedNotesKeys);
                  controller.model.selectedNotesKeys.clear();
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Todos as notas foram excluídas!')),
                );
              },
              icon: Icon(Icons.delete),
            )
          ],
        )
      : AppBar(title: Text('Minhas Notas'));

  Widget _buildItems(item, BuildContext context, key) => Card(
        child: ListTile(
          leading: controller.model.selectedNotesKeys.contains(key)
              ? CircleAvatar(child: Icon(Icons.check))
              : Icon(Icons.note),
          title: Text(
            item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            'Editada em ${item.updatedAt.toString()}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () => onItemTap(item, key),
          onLongPress: () => onItemLongPress(key),
          selected: controller.model.selectedNotesKeys.contains(key),
          selectedTileColor: Colors.indigo[50],
        ),
      );

  void addOrRemoveAllToSelectedItemsList() => setState(() {
        if (controller.model.selectedNotesKeys.isNotEmpty &&
            controller.model.selectedNotesKeys.length == boxNotes.keys.length) {
          controller.model.selectedNotesKeys.clear();
        } else if (controller.model.selectedNotesKeys.length ==
            boxNotes.keys.length) {
          controller.model.selectedNotesKeys.clear();
        } else {
          controller.model.selectedNotesKeys
            ..clear()
            ..addAll(boxNotes.keys.toList());
        }
      });

  void onItemLongPress(key) {
    setState(() => controller.model.selectedNotesKeys.contains(key)
        ? controller.model.selectedNotesKeys.remove(key)
        : controller.model.selectedNotesKeys.add(key));
  }

  void onItemTap(item, key) {
    controller.model.selectedNotesKeys.isNotEmpty
        ? setState(() => controller.model.selectedNotesKeys.contains(key)
            ? controller.model.selectedNotesKeys.remove(key)
            : controller.model.selectedNotesKeys.add(key))
        : Navigator.pushNamed(
            context,
            '/vizualizer',
            arguments: {'note': item, 'key': key},
          );
  }
}
