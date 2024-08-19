import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:fluttermarkdown/utils.dart';
import 'package:markdown/markdown.dart' as md;

class MdCodeElementBuilder extends MarkdownElementBuilder {
  @override
  Widget visitElementAfter(md.Element element, TextStyle? preferredStyle) =>
      !element.textContent.contains('\n')
          ? singleLineWidget(element)
          : multlineCodeWidget(element);

  Widget singleLineWidget(md.Element element) => RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                color: codeblockBackground,
                child: Text(
                  element.textContent.trim(),
                  textAlign: TextAlign.justify,
                  style: githubTheme['root']?.copyWith(
                    fontFamily: 'SourceCodePro',
                    color: Color(0xff990000),
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      );

  Widget multlineCodeWidget(md.Element element) => SizedBox(
        width: double.infinity,
        child: HighlightView(
          element.textContent,
          language:
              element.attributes['class']?.replaceFirst('language-', '') ??
                  'plaintext',
          theme: githubTheme,
          padding: EdgeInsets.all(8.0),
          textStyle: TextStyle(
            fontFamily: 'SourceCodePro',
            fontSize: 14.0,
          ),
        ),
      );
}
