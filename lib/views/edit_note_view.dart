import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:fluttermarkdown/boxes.dart';
import 'package:fluttermarkdown/classes/note.dart';

class EditNoteView extends StatefulWidget {
  const EditNoteView({super.key});

  @override
  State<EditNoteView> createState() => _EditNoteViewState();
}

class _EditNoteViewState extends State<EditNoteView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _titleController;
  late TextEditingController _bodyController;
  late Map? args;
  Note? note;
  dynamic key;
  String oldTitle = '';
  String oldBody = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _titleController = TextEditingController();
    _bodyController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    args = ModalRoute.of(context)!.settings.arguments as Map?;

    if (args != null) {
      note = args!['note'];
      key = args!['key'];
    }

    if (args != null) {
      oldTitle = note!.title;
      oldBody = note!.body;
      _titleController.text = note!.title;
      _bodyController.text = note!.body;
    }
  }

  @override
  void dispose() {
    super.dispose();

    _tabController.dispose();
    _titleController.dispose();
    _bodyController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isEdited =
        _titleController.text != oldTitle || _bodyController.text != oldBody;

    return Scaffold(
      appBar: AppBar(
        title: Text('Minha nota'),
        actions: [
          TextButton.icon(
            onPressed: isEdited ? saveNote : null,
            icon: Icon(Icons.save),
            label: Text('Salvar'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: Icon(Icons.edit),
              text: 'Editar',
            ),
            Tab(
              icon: Icon(Icons.remove_red_eye),
              text: 'Preview',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _editTab(),
          _previewTab(),
        ],
      ),
    );
  }

  Widget _editTab() => Container(
        margin: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.title),
                border: InputBorder.none,
                hintText: 'Título',
              ),
              onChanged: onTitleChanged,
            ),
            SizedBox(height: 8),
            Divider(),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: TextField(
                  controller: _bodyController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Digite sua nota aqui',
                  ),
                  onChanged: onBodyChanged,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _previewTab() => ListView(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 38.0),
        children: [
          Text(
            _titleController.text,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0, bottom: 24.0),
            child: Divider(),
          ),
          MarkdownBody(data: _bodyController.text),
        ],
      );

  void onTitleChanged(String _) => setState(() {});

  void onBodyChanged(String _) => setState(() {});

  void saveNote() {
    String title;

    // verifica se o título está vazio
    if (_titleController.text.isEmpty) {
      final bodyFirstLine = _bodyController.text.split('\n')[0];

      // remove caracteres que não sejam letras (com ou sem acentos), números ou espaços
      final sanitizedTitle =
          bodyFirstLine.replaceAll(RegExp(r'[^a-zA-Z0-9\sÀ-ÿ]'), '');

      // pega as quatro primeiras palavras
      final words = sanitizedTitle
          .split(RegExp(r'\s+'))
          .where((word) => word.isNotEmpty)
          .toList();

      // pega as quatro primeiras palavras e as junta de volta em uma string, separadas por espaços
      final shortenedTitle = words.take(4).join(' ');

      title = shortenedTitle;
    } else
      title = _titleController.text;

    try {
      final note = Note(
        title: title,
        body: _bodyController.text,
        createdAt: this.note?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (args != null)
        boxNotes.put(key, note);
      else
        boxNotes.add(note);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sua nota foi salva!')),
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/',
        (Route<dynamic> route) => false,
      );
    } on Exception catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Houve um erro desconhecido ao salvar sua nota.'),
        ),
      );
    }
  }
}
