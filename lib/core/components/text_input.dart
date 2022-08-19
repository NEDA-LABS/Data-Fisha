import 'package:flutter/material.dart';

textInput(
    {@required Function(String) onText,
    String placeholder = '',
    String label = ''}) {
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
        decoration: const BoxDecoration(
            color: Colors.white,
            border: Border.fromBorderSide(BorderSide(color: Colors.black))),
        child: TextField(
          autofocus: false,
          maxLines: 1,
          minLines: 1,
          onChanged: onText,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: placeholder,
            contentPadding: EdgeInsets.all(8)
            // labelText: label,
            // label: Text(''),
          ),
        ),
      )
    ],
  );
}
