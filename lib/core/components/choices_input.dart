import 'package:flutter/material.dart';
import 'package:smartstock_pos/core/components/input_box_decoration.dart';
import 'package:smartstock_pos/core/components/input_error_message.dart';

choicesInput(
    {@required Function(String) onText,
    String initialText = '',
    String label = '',
    String error = ''}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: Text(label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w200)),
      ),
      Builder(
          builder: (context) => Container(
                // height: 40,
                decoration: inputBoxDecoration(context, error),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: TextEditingController(text: initialText),
                      onChanged: onText,
                      autofocus: false,
                      maxLines: 1,
                      minLines: 1,
                      readOnly: true,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(8)),
                    )),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.arrow_drop_down)),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.refresh)),
                  ],
                ),
              )),
      inputErrorMessageOrEmpty(error)
    ],
  );
}
