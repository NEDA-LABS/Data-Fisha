import 'package:flutter/material.dart';
import 'package:smartstock/core/components/LabelMedium.dart';
import 'package:smartstock/core/components/choice_input_dropdown.dart';
import 'package:smartstock/core/components/full_screen_dialog.dart';
import 'package:smartstock/core/components/input_box_decoration.dart';
import 'package:smartstock/core/components/input_error_message.dart';
import 'package:smartstock/core/services/util.dart';

class ChoicesInput extends StatefulWidget {
  final Function(dynamic) onText;
  final Future Function({bool skipLocal}) onLoad;
  final Widget Function()? getAddWidget;
  final String initialText;
  final String label;
  final String placeholder;
  final String error;
  final Function(dynamic) onField;
  final bool showBorder;
  final bool multiple;

  const ChoicesInput({
    Key? key,
    required this.onText,
    required this.onLoad,
    this.getAddWidget,
    this.initialText = '',
    this.label = '',
    this.placeholder = '',
    this.error = '',
    this.showBorder = true,
    this.multiple = false,
    required this.onField,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ChoicesInput> {
  final _states = {};
  final _getData = propertyOr('data', (_) => []);
  final _getIsLoading = propertyOr('loading', (_) => false);
  final _getSkip = propertyOr('skip', (_) => false);
  TextEditingController? textController;

  @override
  void initState() {
    textController = TextEditingController(text: widget.initialText);
    _onRefresh(skip: false);
    super.initState();
  }

  _updateState(Map state) {
    setState(() {
      _states.addAll(state);
    });
  }

  _fullWidthText() {
    return Expanded(
      child: TextField(
        onTap: () {
          _showDialogOrModalSheetForChoose(context, (text) {
            textController = TextEditingController(
              text: text is List
                  ? text.map((e) => widget.onField(e)).join(',')
                  : '$text',
            );
            _updateState({});
            widget.onText(text);
          }, widget.onField);
          // _showOptions(widget.onText, widget.onField);
        },
        controller: textController,
        onChanged: widget.multiple ? null : widget.onText,
        autofocus: false,
        maxLines: 1,
        minLines: 1,
        readOnly: true,
        decoration: InputDecoration(
          hintText: widget.placeholder,
          hintStyle: const TextStyle(
            color: Color(0xffb0b0b0),
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(8),
        ),
      ),
    );
  }

  _label(label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: LabelMedium(
        text: label,
        // style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w200),
      ),
    );
  }

  _actionsItems(
      onRefresh, onText, getAddWidget, onField, BuildContext context) {
    return Row(children: [
      IconButton(
          onPressed: _showOptions(onText, onField),
          icon: const Icon(Icons.arrow_drop_down)),
      getAddWidget != null
          ? IconButton(
              onPressed: () => _showDialogForAdd(getAddWidget(), context),
              icon: const Icon(Icons.add))
          : Container(),
      IconButton(onPressed: onRefresh, icon: const Icon(Icons.refresh))
    ]);
  }

  _actions(Function onRefresh, onText, onAdd, onField) => _getIsLoading(_states)
      ? const Padding(
          padding: EdgeInsets.fromLTRB(4, 0, 8, 0),
          child: SizedBox(
              height: 16, width: 16, child: CircularProgressIndicator()))
      : _actionsItems(onRefresh, onText, onAdd, onField, context);

  _showDialogOrModalSheetForChoose(context, onText, onField) {
    return !getIsSmallScreen(context)
        ? showDialog(
            context: context,
            builder: (_) {
              return Dialog(
                child: Container(
                  constraints: const BoxConstraints(
                      maxWidth: 500, minHeight: 300, maxHeight: 600),
                  child: ChoiceInputDropdown(
                    items: itOrEmptyArray(_getData(_states)),
                    onTitle: onField,
                    onText: onText,
                    multiple: widget.multiple,
                    label: widget.placeholder,
                  ),
                ),
              );
            },
          )
        : fullScreeDialog(
            context,
            (p0) => Container(
              color: Theme.of(context).colorScheme.surface,
              child: ChoiceInputDropdown(
                items: itOrEmptyArray(_getData(_states)),
                onTitle: onField,
                onText: onText,
                multiple: widget.multiple,
                label: widget.placeholder,
              ),
            ),
          );
    // showModalBottomSheet(
    //         isScrollControlled: true,
    //         enableDrag: true,
    //         context: context,
    //         builder: (context) => FractionallySizedBox(
    //           heightFactor: 0.9,
    //           child: ChoiceInputDropdown(
    //             items: itOrEmptyArray(_getData(_states)),
    //             onTitle: onField,
    //             onText: onText,
    //             multiple: widget.multiple,
    //             label: widget.placeholder,
    //           ),
    //         ),
    //       );
  }

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

  _showOptions(onText, onField) =>
      () => _showDialogOrModalSheetForChoose(context, onText, onField);

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
              _fullWidthText(),
              _actions(
                _onRefresh,
                (text) {
                  textController = TextEditingController(
                    text: text is List
                        ? text.map((e) => widget.onField(e)).join(',')
                        : '$text',
                  );
                  _updateState({});
                  widget.onText(text);
                },
                widget.getAddWidget,
                widget.onField,
              )
            ])),
        inputErrorMessageOrEmpty(widget.error)
      ]);
}
