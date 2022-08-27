import 'package:flutter/material.dart';

import 'input_box_decoration.dart';
import 'input_error_message.dart';

const _b = SizedBox();

_labelStyle() => const TextStyle(fontSize: 14, fontWeight: FontWeight.w200);

_labelPadding() => const EdgeInsets.fromLTRB(0, 8, 0, 8);

_label(label) => Padding(
    padding: _labelPadding(), child: Text(label ?? '', style: _labelStyle()));

_inputPadding() => const EdgeInsets.all(8);

_inputDecoration(String hint) => InputDecoration(
    border: InputBorder.none,
    hintText: hint ?? '',
    contentPadding: _inputPadding());

_input(error, onText, type, placeholder, icon, lines) => Builder(
      builder: (context) => Container(
        decoration: inputBoxDecoration(context, error),
        child: Row(
          children: [
            _fulWidthTextField(onText, type, placeholder, lines),
            icon
          ],
        ),
      ),
    );

_fulWidthTextField(onText, type, placeholder, lines) => Expanded(
        child: TextField(
      autofocus: false,
      maxLines: lines,
      onChanged: onText,
      keyboardType: type,
      decoration: _inputDecoration(placeholder),
    ));

textInput({
  @required Function(String) onText,
  String initialText = '',
  String placeholder = '',
  String label = '',
  Widget icon = _b,
  TextInputType type = TextInputType.text,
  String error = '',
  int lines = 1,
}) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label is String && label.isEmpty ? Container(height: 10,) : _label(label),
        _input(error, onText, type, placeholder, icon, lines),
        inputErrorMessageOrEmpty(error),
      ],
    );
