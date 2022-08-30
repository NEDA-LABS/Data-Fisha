import 'package:flutter/material.dart';
import 'package:smartstock_pos/core/components/choice_input_dropdown.dart';
import 'package:smartstock_pos/core/components/input_box_decoration.dart';
import 'package:smartstock_pos/core/components/input_error_message.dart';
import 'package:smartstock_pos/core/services/util.dart';

class ChoicesInput extends StatefulWidget {
  final Function(String) onText;
  final Future Function({bool skipLocal}) onLoad;
  final Widget Function() getAddWidget;
  final String initialText;
  final String label;
  final String placeholder;
  final String error;
  final Function(dynamic) onField;
  final bool showBorder;

  const ChoicesInput({
    Key key,
    @required this.onText,
    @required this.onLoad,
    @required this.getAddWidget,
    this.initialText = '',
    this.label = '',
    this.placeholder = '',
    this.error = '',
    this.showBorder = true,
    @required this.onField,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChoicesInputState();
}

class _ChoicesInputState extends State<ChoicesInput> {
  final _states = {};
  final _getData = propertyOr('data', (_) => []);
  final _getIsLoading = propertyOr('loading', (_) => false);
  final _getSkip = propertyOr('skip', (_) => false);

  @override
  void initState() {
    _onRefresh(skip: false);
    super.initState();
  }

  _updateState(Map state) {
    setState(() {
      _states.addAll(state);
    });
  }

  _fullWidthText(onText, String hintText, initialText) => Expanded(
      child: TextField(
          controller: TextEditingController(text: initialText),
          onChanged: onText,
          autofocus: false,
          maxLines: 1,
          minLines: 1,
          readOnly: true,
          decoration: InputDecoration(
              hintText: hintText ?? '',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(8))));

  _label(label) => Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Text(label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w200)));

  _actionsItems(data, onRefresh, onText, getAddWidget, onField,
          BuildContext context) =>
      Row(children: [
        IconButton(
            onPressed: _showOptions(data, onText, onField),
            icon: const Icon(Icons.arrow_drop_down)),
        IconButton(
            onPressed: () => _showDialogForAdd(getAddWidget(), context),
            icon: const Icon(Icons.add)),
        IconButton(onPressed: onRefresh, icon: const Icon(Icons.refresh))
      ]);

  _actions(Function onRefresh, onText, onAdd, onField) => _getIsLoading(_states)
      ? const Padding(
          padding: EdgeInsets.fromLTRB(4, 0, 8, 0),
          child: SizedBox(
              height: 16, width: 16, child: CircularProgressIndicator()))
      : _actionsItems(
          _getData(_states), onRefresh, onText, onAdd, onField, context);

  _showDialogOrModalSheetForChoose(context, List items, onText, onField) =>
      hasEnoughWidth(context)
          ? showDialog(
              context: context,
              builder: (_) => Dialog(
                  child: Container(
                      constraints:
                          const BoxConstraints(maxWidth: 500, maxHeight: 300),
                      child: ChoiceInputDropdown(
                          items: items, onTitle: onField, onText: onText))))
          : showModalBottomSheet(
              isScrollControlled: true,
              enableDrag: true,
              context: context,
              builder: (context) => FractionallySizedBox(
                  heightFactor: 0.7,
                  child: ChoiceInputDropdown(
                      items: items, onTitle: onField, onText: onText)));

  _showDialogForAdd(Widget content, context) => showDialog(
      context: context,
      builder: (_) => Dialog(
          child: Container(
              constraints: const BoxConstraints(
                  maxWidth: 500, minHeight: 200, maxHeight: 600),
              child: content)));

  _onRefresh({skip = true}) {
    _updateState({'skip': skip, 'loading': true});
    widget
        .onLoad(skipLocal: _getSkip(_states))
        .then((value) =>
            _updateState({'data': value, 'skip': false, 'loading': false}))
        .whenComplete(() => _updateState({'skip': false, 'loading': false}));
  }

  _showOptions(data, onText, onField) => () => _showDialogOrModalSheetForChoose(
      context, itOrEmptyArray(data), onText, onField);

  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        widget.label.isNotEmpty
            ? _label(widget.label)
            : const SizedBox(height: 0),
        Container(
            decoration: widget.showBorder
                ? inputBoxDecoration(context, widget.error)
                : null,
            child: Row(children: [
              _fullWidthText(
                  widget.onText, widget.placeholder, widget.initialText),
              _actions(_onRefresh, widget.onText, widget.getAddWidget,
                  widget.onField)
            ])),
        inputErrorMessageOrEmpty(widget.error)
      ]);
}
