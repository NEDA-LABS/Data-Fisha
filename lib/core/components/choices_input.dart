import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:smartstock_pos/core/components/active_component.dart';
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
          border: InputBorder.none, contentPadding: EdgeInsets.all(8)),
    ));

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
                      onText),
                ),
              ],
            ),
          ),
        ),
        inputErrorMessageOrEmpty(error)
      ],
    );

_actionsItems(AsyncSnapshot snapshot, Function([Map value]) updateState,
        Function(String p1) onText) =>
    Row(children: [
      Builder(builder: (context) {
        return IconButton(
            onPressed: () => showDialogOrModalSheet(
                itOrEmptyArray(snapshot.data), onText)(context),
            icon: const Icon(Icons.arrow_drop_down));
      }),
      // IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
      IconButton(
          onPressed: () => updateState({'skip': true}),
          icon: const Icon(Icons.refresh))
    ]);
var _isLoading =
    (x) => x is AsyncSnapshot && x.connectionState == ConnectionState.waiting;

_actions(Future<dynamic> future, Function([Map value]) updateState,
        Function(String p1) onText) =>
    FutureBuilder(
      future: future,
      builder: (context, snapshot) => ifDoElse(
        _isLoading,
        (_) => const Padding(
          padding: EdgeInsets.fromLTRB(4, 0, 8, 0),
          child: SizedBox(
              height: 16, width: 16, child: CircularProgressIndicator()),
        ),
        (x) => _actionsItems(x, updateState, onText),
      )(snapshot),
    );

showDialogOrModalSheet(List items, Function(String p1) onText) => ifDoElse(
    (x) => hasEnoughWidth(x),
    (x) => showDialog(
          context: x,
          builder: (_) => Dialog(
            child: Container(
              child: _dropDownContent(items, onText),
              constraints: const BoxConstraints(
                  maxWidth: 400, minHeight: 200, maxHeight: 300),
            ),
          ),
        ),
    (x) => showModalBottomSheet(
        context: x, builder: (context) => _dropDownContent(items, onText)));

_dropDownContent(List items, Function(String p1) onText) => ListView.builder(
      itemCount: items is List ? items.length : 0,
      itemBuilder: (context, index) => ListTile(
        title: Text(items[index]['name'] ?? ''),
        onTap: (){
          onText(
            items[index]['name'],
          );
          navigator().maybePop();
        },
      ),
    );
