import 'package:flutter/cupertino.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/TextAreaInput.dart';

class ProductDescriptionInput extends StatelessWidget {
  final void Function(String value) onText;
  final String error;
  final String text;

  const ProductDescriptionInput(
      {super.key, required this.onText, this.error = '', this.text=''});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const BodyLarge(text: "Description ( Optional )"),
        TextAreaInput(onText: onText, error: error, text: text,),
      ],
    );
  }
}
