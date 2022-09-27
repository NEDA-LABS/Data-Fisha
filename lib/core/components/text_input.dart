import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smartstock/core/components/input_box_decoration.dart';
import 'package:smartstock/core/components/input_error_message.dart';

const _b = SizedBox();

class TextInput extends StatefulWidget {
  final Function(String) onText;
  final String initialText;
  final String placeholder;
  final String error;
  final String label;
  final Widget icon;
  final TextInputType type;
  final int lines;
  final dynamic debounceTime;
  final bool show;

  const TextInput({
    Key? key,
    required this.onText,
    this.initialText = '',
    this.placeholder = '',
    this.label = '',
    this.icon = _b,
    this.type = TextInputType.text,
    this.error = '',
    this.lines = 1,
    this.debounceTime = 250,
    this.show = true,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  TextEditingController? controller;
  Timer? _debounce;

  _labelStyle() => const TextStyle(fontSize: 14, fontWeight: FontWeight.w200);

  _labelPadding() => const EdgeInsets.fromLTRB(0, 8, 0, 8);

  _label(label) => Padding(
      padding: _labelPadding(), child: Text(label ?? '', style: _labelStyle()));

  _inputPadding() => const EdgeInsets.all(8);

  _inputDecoration(String hint) => InputDecoration(
      border: InputBorder.none,
      hintText: hint,
      contentPadding: _inputPadding());

  _input(error, onText, type, placeholder, icon, lines,
          TextEditingController? controller, debounceTime, show) =>
      Builder(
        builder: (context) => Container(
          decoration: inputBoxDecoration(context, error),
          child: Row(
            children: [
              _fulWidthTextField(onText, type, placeholder, lines, controller,
                  debounceTime, show),
              Padding(padding: const EdgeInsets.all(5), child: icon)
            ],
          ),
        ),
      );

  _fulWidthTextField(onText, type, placeholder, lines,
          TextEditingController? controller, debounceTime, show) =>
      Expanded(
          child: TextField(
        controller: controller,
        autofocus: false,
        maxLines: lines,
        onChanged: (text) {
          if (_debounce?.isActive ?? false) _debounce!.cancel();
          _debounce = Timer(
            Duration(milliseconds: debounceTime),
            () => onText(text),
          );
        },
        keyboardType: type,
        decoration: _inputDecoration(placeholder),
        obscureText: show == false,
      ));

  @override
  void initState() {
    controller = TextEditingController(text: widget.initialText);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.label.isEmpty ? Container(height: 10) : _label(widget.label),
          _input(
              widget.error,
              widget.onText,
              widget.type,
              widget.placeholder,
              widget.icon,
              widget.lines,
              controller,
              widget.debounceTime,
              widget.show),
          inputErrorMessageOrEmpty(widget.error),
        ],
      );

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
