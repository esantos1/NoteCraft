import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class EditNoteView extends StatefulWidget {
  const EditNoteView({super.key});

  @override
  State<EditNoteView> createState() => _EditNoteViewState();
}

class _EditNoteViewState extends State<EditNoteView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Map<String, String> args;
  late TextEditingController _textController;
  String text = '';

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Obtemos os argumentos passados para a rota
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final title = args['title']!;
    text = args['body']!;

    // Inicializamos o TextEditingController com o corpo da nota
    _textController = TextEditingController(text: text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton.icon(
            onPressed: () {},
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
          Container(
            margin: EdgeInsets.all(16),
            child: TextField(
              controller: _textController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Digite sua nota aqui',
              ),
              onChanged: onInputChanged,
            ),
          ),
          Container(
            margin: EdgeInsets.all(16),
            child: MarkdownBody(data: text),
          ),
        ],
      ),
    );
  }

  void onInputChanged(String value) => setState(() => text = value);
}
