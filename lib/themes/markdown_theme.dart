import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:fluttermarkdown/utils.dart';

class MarkdownTheme {
  static MarkdownStyleSheet getMarkdownStyleSheet(BuildContext context) {
    final theme = Theme.of(context);

    return MarkdownStyleSheet(
      textAlign: WrapAlignment.spaceBetween,
      h1: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
        color: theme.primaryColor,
      ),
      h2: TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.w600,
        color: theme.primaryColor.withOpacity(0.9),
      ),
      h3: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w600,
        color: theme.primaryColor.withOpacity(0.8),
      ),
      h4: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w900,
        color: theme.primaryColor.withOpacity(0.8),
      ),
      h5: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w900,
        color: theme.primaryColor.withOpacity(0.8),
      ),
      h6: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w900,
        color: theme.primaryColor.withOpacity(0.8),
      ),
      code: TextStyle(
        fontFamily: 'SourceCodePro',
        backgroundColor: Colors.transparent,
        color: Colors.deepOrangeAccent,
        fontSize: 14.0,
        overflow: TextOverflow.ellipsis,
      ),
      codeblockDecoration: BoxDecoration(
        color: codeblockBackground,
        borderRadius: BorderRadius.circular(8.0),
      ),
      p: TextStyle(
        fontSize: 16.0,
        color: Colors.black87,
        height: 2,
      ),
    );
  }
}
