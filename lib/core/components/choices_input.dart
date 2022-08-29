import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:smartstock_pos/core/components/active_component.dart';
import 'package:smartstock_pos/core/components/choice_input_dropdown.dart';
import 'package:smartstock_pos/core/components/input_box_decoration.dart';
import 'package:smartstock_pos/core/components/input_error_message.dart';
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
            border: InputBorder.none, contentPadding: EdgeInsets.all(8))));

_label(label) => Padding(
    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
    child: Text(label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w200)));

_actionsItems(
  AsyncSnapshot snapshot,
  Function([Map value, bool]) updateState,
  Function(String p1) onText,
  onAdd,
  Function(dynamic) field,
  BuildContext context,
) {
  updateState({'skip': false}, true);
  return Row(children: [
    IconButton(
        onPressed: () => _showDialogOrModalSheetForChoose(
            itOrEmptyArray(snapshot.data), onText, field)(context),
        icon: const Icon(Icons.arrow_drop_down)),
    IconButton(
        onPressed: () =>
            _showDialogOrModalSheetForAdd(onAdd(), context)(context),
        icon: const Icon(Icons.add)),
    IconButton(
        onPressed: () => updateState({'skip': true}),
        icon: const Icon(Icons.refresh))
  ]);
}

var _isLoading =
    (x) => x is AsyncSnapshot && x.connectionState == ConnectionState.waiting;

_actions(
  Future<dynamic> future,
  Function([Map value]) updateState,
  Function(String p1) onText,
  onAdd,
  Function(dynamic) field,
) =>
    FutureBuilder(
        future: future,
        builder: (context, snapshot) => _isLoading(snapshot)
            ? const Padding(
                padding: EdgeInsets.fromLTRB(4, 0, 8, 0),
                child: SizedBox(
                    height: 16, width: 16, child: CircularProgressIndicator()))
            : _actionsItems(
                snapshot, updateState, onText, onAdd, field, context));

_showDialogOrModalSheetForChoose(
        List items, Function(String p1) onText, Function(dynamic) field) =>
    ifDoElse(
        (x) => hasEnoughWidth(x),
        (x) => showDialog(
            context: x,
            builder: (_) => Dialog(
                child: Container(
                    constraints:
                        const BoxConstraints(maxWidth: 500, maxHeight: 300),
                    child: ChoiceInputDropdown(
                        items: items, onTitle: field, onText: onText)))),
        (x) => showBottomSheet(
            // isScrollControlled: true,
            enableDrag: true,
            context: x,
            builder: (context) => FractionallySizedBox(
                  // heightFactor: 0.9,
                  child: ChoiceInputDropdown(
                      items: items, onTitle: field, onText: onText),
                )));

_showDialogOrModalSheetForAdd(Widget content, context) => ifDoElse(
    (x) => true,// hasEnoughWidth(x),
    (x) => showDialog(
        context: x,
        builder: (_) => Dialog(
            child: Container(
                constraints: const BoxConstraints(
                    maxWidth: 500, minHeight: 200, maxHeight: 600),
                child: content))),
    (x) => showModalBottomSheet(
        isScrollControlled: true,
        context: x,
        builder: (_) => FractionallySizedBox(
            heightFactor: 0.9,
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                    child: Center(
                      child: Container(
                        height: 8,
                        width: 80,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorDark,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50))),
                      ),
                    ),
                  ),
                  content,
                ],
              ),
            ))));

choicesInput({
  @required Function(String) onText,
  @required Future Function({bool skipLocal}) onLoad,
  @required Widget Function() onAdd,
  String initialText = '',
  String label = '',
  String error = '',
  @required Function(dynamic) field,
}) =>
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _label(label),
      ActiveComponent(builder: (context, states, updateState) => Container(
          decoration: inputBoxDecoration(context, error),
          child: Row(children: [
            _fullWidthText(onText, initialText),
            _actions(onLoad(skipLocal: states['skip'] == true), updateState,
                onText, onAdd, field)
          ]))),
      inputErrorMessageOrEmpty(error)
    ]);
