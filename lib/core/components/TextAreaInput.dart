import 'package:flutter/cupertino.dart';
import 'package:smartstock/core/components/TextInput.dart';
import 'package:smartstock/core/services/custom_text_editing_controller.dart';
import 'package:smartstock/stocks/helpers/markdown_map.dart';

class TextAreaInput extends StatefulWidget {
  final String text;
  final String error;
  final void Function(String value) onText;

  const TextAreaInput({
    super.key,
    this.text = '',
    required this.onText,
    this.error = '',
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<TextAreaInput> {
  CustomTextEditingController? _controller;

  @override
  void initState() {
    _controller = CustomTextEditingController(
      getTextEditorMDMap,
      text: widget.text,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextInput(
      lines: 6,
      type: TextInputType.multiline,
      controller: _controller,
      onText: widget.onText,
      label: "Decorate with *bold*, ~strike~, _italic_",
      error: widget.error,
    );
  }
}
