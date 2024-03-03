import 'package:flutter/cupertino.dart';
import 'package:smartstock/core/components/TextInput.dart';

class ProductNameInput extends StatelessWidget {
  final void Function(String value) onText;
  final String error;
  final String text;

  const ProductNameInput(
      {super.key, required this.onText, this.text = '', this.error = ''});

  @override
  Widget build(BuildContext context) {
    return TextInput(
      onText: onText,
      label: "Waste name",
      placeholder: '',
      error: error,
      initialText: text,
    );
  }
}
