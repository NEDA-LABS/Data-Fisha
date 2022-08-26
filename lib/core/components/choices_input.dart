import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:smartstock_pos/core/components/active_component.dart';
import 'package:smartstock_pos/core/components/choice_input_content.dart';
import 'package:smartstock_pos/core/components/input_box_decoration.dart';
import 'package:smartstock_pos/core/components/input_error_message.dart';
import 'package:smartstock_pos/core/components/text_input.dart';
import 'package:smartstock_pos/core/services/util.dart';

_fullWidthText(onText, initialText) => Expanded(
      child: TextField(
        controller: TextEditingController(text: initialText),
        onChanged: onText,
        autofocus: false,
        maxLines: 1,
        minLines: 1,
        readOnly: true,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(8),
        ),
      ),
    );

_label(label) => Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Text(label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w200)),
    );

choicesInput({
  @required Function(String) onText,
  @required Future Function({bool skipLocal}) onLoad,
  @required Widget Function() onAdd,
  String initialText = '',
  String label = '',
  String error = '',
  @required Function(dynamic) field,
}) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        Builder(
          builder: (context) => Container(
            decoration: inputBoxDecoration(context, error),
            child: Row(
              children: [
                _fullWidthText(onText, initialText),
                ActiveComponent(
                  (states, updateState) => _actions(
                    onLoad(skipLocal: states['skip'] == true),
                    updateState,
                    onText,
                    onAdd,
                    field,
                  ),
                ),
              ],
            ),
          ),
        ),
        inputErrorMessageOrEmpty(error)
      ],
    );

_actionsItems(AsyncSnapshot snapshot, Function([Map value]) updateState,
        Function(String p1) onText, onAdd, Function(dynamic) field) =>
    Row(children: [
      Builder(builder: (context) {
        return IconButton(
            onPressed: () => showDialogOrModalSheetForChoose(
                itOrEmptyArray(snapshot.data), onText, field)(context),
            icon: const Icon(Icons.arrow_drop_down));
      }),
      Builder(builder: (context) {
        return IconButton(
            onPressed: () => showDialogOrModalSheetForAdd(onAdd())(context),
            icon: const Icon(Icons.add));
      }),
      IconButton(
        onPressed: () => updateState({'skip': true}),
        icon: const Icon(Icons.refresh),
      )
    ]);
var _isLoading =
    (x) => x is AsyncSnapshot && x.connectionState == ConnectionState.waiting;

_actions(Future<dynamic> future, Function([Map value]) updateState,
        Function(String p1) onText, onAdd, Function(dynamic) field) =>
    FutureBuilder(
      future: future,
      builder: (context, snapshot) => ifDoElse(
        _isLoading,
        (_) => const Padding(
          padding: EdgeInsets.fromLTRB(4, 0, 8, 0),
          child: SizedBox(
              height: 16, width: 16, child: CircularProgressIndicator()),
        ),
        (x) => _actionsItems(x, updateState, onText, onAdd, field),
      )(snapshot),
    );

showDialogOrModalSheetForChoose(
        List items, Function(String p1) onText, Function(dynamic) field) =>
    ifDoElse(
      (x) => hasEnoughWidth(x),
      (x) => showDialog(
        context: x,
        builder: (_) => Dialog(
          child: Container(
            child: _dropDownContent(items, onText, field),
            constraints: const BoxConstraints(
              maxWidth: 400,
              // minHeight: 200,
              maxHeight: 300,
            ),
          ),
        ),
      ),
      (x) => showModalBottomSheet(
        context: x,
        builder: (context) => _dropDownContent(
            items.isNotEmpty
                ? items
                : [
                    {
                      [field]: 'General'
                    }
                  ],
            onText,
            field),
      ),
    );

showDialogOrModalSheetForAdd(Widget content) => ifDoElse(
      (x) => hasEnoughWidth(x),
      (x) => showDialog(
        context: x,
        builder: (_) => Dialog(
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 500,
              minHeight: 200,
              maxHeight: 600,
            ),
            child: content,
          ),
        ),
      ),
      (x) => showModalBottomSheet(context: x, builder: (_) => content),
    );

_dropDownContent(
  List items,
  Function(String p1) onText,
  Function(dynamic) field,
) =>
    ChoiceInputContent(items: items, onTitle: field, onText: onText);
// Padding(
//   padding: const EdgeInsets.all(8.0),
//   child: Column(
//     children: [
//       textInput(onText: (d){}, placeholder: 'Search...'),
//       Expanded(
//         child: ListView.builder(
//           itemCount: items is List ? items.length : 0,
//           itemBuilder: (context, index) => ListTile(
//             title: Text('${field(items[index])}' ?? ''),
//             onTap: () {
//               onText(field(items[index]));
//               navigator().maybePop();
//             },
//           ),
//         ),
//       ),
//     ],
//   ),
// );
