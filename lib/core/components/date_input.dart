import 'package:flutter/material.dart';
import 'package:smartstock/core/components/input_box_decoration.dart';
import 'package:smartstock/core/components/input_error_message.dart';
import 'package:smartstock/core/services/date.dart';
import 'package:smartstock/core/services/util.dart';

class DateInput extends StatefulWidget {
  final Function(String) onText;
  final String initialText;
  final String label;
  final String placeholder;
  final String? error;
  final bool showBorder;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime initialDate;

  const DateInput({
    Key? key,
    required this.onText,
    this.initialText = '',
    this.label = '',
    this.placeholder = '',
    this.error = '',
    this.showBorder = true,
    required this.firstDate,
    required this.initialDate,
    required this.lastDate,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  final _states = {};
  final _getData = propertyOr('data', (_) => []);
  final _getIsLoading = propertyOr('loading', (_) => false);
  TextEditingController? textController;

  @override
  void initState() {
    textController = TextEditingController(text: widget.initialText);
    super.initState();
  }

  _updateState(Map state) {
    setState(() {
      _states.addAll(state);
    });
  }

  _fullWidthText(onText, String hintText, initialText) => Expanded(
      child: TextField(
          controller: textController,
          onTap: _showDate,
          onChanged: onText,
          autofocus: false,
          maxLines: 1,
          minLines: 1,
          readOnly: true,
          decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(8))));

  _label(label) => Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Text(label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w200)));

  _actionsItems(data, BuildContext context) => Row(children: [
        IconButton(
            onPressed: _showDate, icon: const Icon(Icons.date_range_outlined))
      ]);

  _actions() => _getIsLoading(_states)
      ? const Padding(
          padding: EdgeInsets.fromLTRB(4, 0, 8, 0),
          child: SizedBox(
              height: 16, width: 16, child: CircularProgressIndicator()))
      : _actionsItems(_getData(_states), context);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.label.isNotEmpty
              ? _label(widget.label)
              : const SizedBox(height: 0),
          Container(
            decoration: widget.showBorder
                ? getInputBoxDecoration(context, widget.error)
                : null,
            child: Row(
              children: [
                _fullWidthText(
                  widget.onText,
                  widget.placeholder,
                  widget.initialText,
                ),
                _actions()
              ],
            ),
          ),
          inputErrorMessageOrEmpty(widget.error)
        ],
      );

  _onText(text) {
    textController = TextEditingController(text: text);
    _updateState({});
    widget.onText(text);
  }

  void _showDate() {
    print('Date clicked');
    showDatePicker(
      context: context,
      initialDate: widget.initialDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    ).then((value) => value != null ? _onText(toSqlDate(value)) : {});
  }
}
