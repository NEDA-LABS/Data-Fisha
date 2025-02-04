import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smartstock/core/components/LabelMedium.dart';
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
  final int? lines;
  final dynamic debounceTime;
  final bool show;
  final bool readOnly;
  final String? value;
  TextEditingController? controller;

  TextInput({
    super.key,
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
    this.readOnly = false,
    this.controller,
    this.value,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<TextInput> {
  Timer? _debounce;

  @override
  void initState() {
    widget.controller =
        widget.controller ?? TextEditingController(text: widget.initialText);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label(),
        _input(context),
        InputErrorMessageOrEmpty(widget.error),
      ],
    );
  }

  _label() {
    var labelPadding = const EdgeInsets.fromLTRB(0, 8, 0, 8);
    // var labelStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.w200);
    var empty = Container(height: 10);
    var label = Padding(
      padding: labelPadding,
      child: LabelMedium(
        text: widget.label,
        // style: labelStyle,
      ),
    );
    return widget.label.isEmpty ? empty : label;
  }

  _input(context) {
    return Container(
      decoration: getInputBoxDecoration(
        context,
        widget.error,
        widget.readOnly ? Theme.of(context).colorScheme.primaryContainer : null,
      ),
      child: Row(
        children: [
          _fulWidthTextField(),
          Padding(padding: const EdgeInsets.all(5), child: widget.icon)
        ],
      ),
    );
  }

  _fulWidthTextField() {
    var inputPadding = const EdgeInsets.all(8);
    var inputDecoration = InputDecoration(
      border: InputBorder.none,
      hintText: widget.placeholder,
      hintStyle: const TextStyle(
          // color: Color(0xffb0b0b0),
          fontSize: 14,
          fontWeight: FontWeight.w300),
      contentPadding: inputPadding,
    );

    return Expanded(
      child: TextField(
        controller: widget.value != null
            ? TextEditingController(text: widget.value)
            : widget.controller,
        autofocus: false,
        maxLines: widget.lines,
        readOnly: widget.readOnly,
        onChanged: (text) {
          if (_debounce?.isActive ?? false) _debounce!.cancel();
          _debounce = Timer(
            Duration(milliseconds: widget.debounceTime),
            () => widget.onText(text),
          );
        },
        keyboardType: widget.type,
        decoration: inputDecoration,
        obscureText: widget.show == false,
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
