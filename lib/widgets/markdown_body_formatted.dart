import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:fluttermarkdown/themes/markdown_theme.dart';
import 'package:fluttermarkdown/widgets/md_code_element_builder.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:markdown/markdown.dart' as md;

class MarkdownBodyFormatted extends StatelessWidget {
  final String data;

  const MarkdownBodyFormatted({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) => ListTile(
        title: Markdown(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          data: data,
          extensionSet: md.ExtensionSet(
            md.ExtensionSet.gitHubFlavored.blockSyntaxes,
            <md.InlineSyntax>[
              md.EmojiSyntax(),
              ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
            ],
          ),
          onTapLink: (text, href, title) => launchUrl(
            Uri.parse(href!),
          ),
          styleSheet: MarkdownTheme.getMarkdownStyleSheet(context),
          builders: {'code': MdCodeElementBuilder()},
        ),
      );
}
