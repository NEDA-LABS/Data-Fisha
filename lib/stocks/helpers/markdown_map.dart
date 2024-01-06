import 'package:flutter/material.dart';

var getTextEditorMDMap = {
  r"@.\w+": const TextStyle(
    color: Colors.blue,
  ),
  r"#.\w+": const TextStyle(
    color: Colors.blue,
  ),
  r'_(.*?)\_': const TextStyle(
    fontStyle: FontStyle.italic,
  ),
  '~(.*?)~': const TextStyle(
    decoration: TextDecoration.lineThrough,
  ),
  r'\*(.*?)\*': const TextStyle(
    fontWeight: FontWeight.bold,
  ),
};