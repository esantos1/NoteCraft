import 'package:flutter/material.dart';
import 'package:fluttermarkdown/boxes.dart';
import 'package:fluttermarkdown/classes/note.dart';
import 'package:fluttermarkdown/widgets/markdown_body_formatted.dart';

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
    bool isEdited = _titleController.text.trim() != oldTitle ||
        _bodyController.text.trim() != oldBody;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        final shouldPop = await _showExitConfirmationDialog(context);

        if (context.mounted && shouldPop) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
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
              textAlignVertical: TextAlignVertical.center,
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
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        children: [
          Text(
            _titleController.text,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Divider(),
          ),
          MarkdownBodyFormatted(data: _bodyController.text)
        ],
      );

  void onTitleChanged(String _) => setState(() {});

  void onBodyChanged(String _) => setState(() {});

  Future<bool> _showExitConfirmationDialog(BuildContext context) async =>
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Alterações Não Salvas'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Você tem alterações não salvas.'),
                Text('Se sair, todas as alterações serão perdidas.'),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.pop(context, false),
            ),
            ElevatedButton(
              child: Text('Sair'),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ),
      ) ??
      false;

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
