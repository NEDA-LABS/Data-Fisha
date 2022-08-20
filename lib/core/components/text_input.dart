import 'package:flutter/material.dart';

const _b = SizedBox();

textInput(
    {@required Function(String) onText,
    String initialText = '',
    String placeholder = '',
    String label = '',
    Widget icon = _b,
    TextInputType type = TextInputType.text,
    String error = ''}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: Text(label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w200)),
      ),
      Container(
        // height: 40,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.fromBorderSide(BorderSide(
                color: error.isNotEmpty
                    ? Colors.red
                    : Colors.black)),
            borderRadius: const BorderRadius.all(Radius.circular(3))),
        child: Row(
          children: [
            Expanded(
                child: TextField(
              controller: TextEditingController(text: initialText),
              autofocus: false,
              maxLines: 1,
              minLines: 1,
              onChanged: onText,
              keyboardType: type,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: placeholder,
                  contentPadding: const EdgeInsets.all(8)
                  // labelText: label,
                  // label: Text(''),
                  ),
            )),
            icon
          ],
        ),
      ),
      error.isNotEmpty && error != null
          ? Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Text(
                error,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                ),
              ),
            )
          : _b
    ],
  );
}
