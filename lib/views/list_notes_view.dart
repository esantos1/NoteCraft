import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttermarkdown/boxes.dart';
import 'package:fluttermarkdown/classes/note.dart';
import 'package:fluttermarkdown/controllers/list_notes_controller.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class ListNotesView extends StatefulWidget {
  const ListNotesView({super.key});

  @override
  State<ListNotesView> createState() => _ListNotesViewState();
}

class _ListNotesViewState extends State<ListNotesView> {
  final controller = ListNotesController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(minutes: 1), (Timer t) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _appBar(),
        body: ValueListenableBuilder(
          valueListenable: boxNotes.listenable(),
          builder: (context, box, _) {
            final notes = box.values.toList();
            notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

            if (notes.isEmpty) {
              return Center(
                child: Text('Você não criou nenhuma nota ainda!'),
              );
            }
            return ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final item = notes[index];
                final key = box.keyAt(box.values.toList().indexOf(item));

                return _buildItems(item, context, key);
              },
            );
          },
        ),
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
                  SnackBar(content: Text('As notas foram excluídas!')),
                );
              },
              icon: Icon(Icons.delete),
            )
          ],
        )
      : AppBar(title: Text('Minhas Notas'));

  Widget _buildItems(Note item, BuildContext context, key) => Card(
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
            formatDate(item.updatedAt),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () => onItemTap(item, key),
          onLongPress: () => onItemLongPress(key),
          selected: controller.model.selectedNotesKeys.contains(key),
          selectedTileColor: Colors.indigo[50],
        ),
      );

  String formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Editado agora há pouco';
    } else if (difference.inMinutes < 60) {
      return 'Editado há ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Editado há ${difference.inHours} h';
    } else if (difference.inDays == 1) {
      return 'Editado ontem';
    } else if (difference.inDays < 7) {
      return 'Editado há ${difference.inDays} dias';
    } else if (dateTime.year == now.year) {
      return 'Editado em ${DateFormat('dd/MM').format(dateTime)}';
    } else {
      return 'Editado em ${DateFormat('dd/MM/yyyy').format(dateTime)}';
    }
  }

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
