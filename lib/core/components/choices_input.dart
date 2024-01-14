import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/DialogContentWrapper.dart';
import 'package:smartstock/core/components/LabelMedium.dart';
import 'package:smartstock/core/components/choice_input_dropdown.dart';
import 'package:smartstock/core/components/full_screen_dialog.dart';
import 'package:smartstock/core/components/input_box_decoration.dart';
import 'package:smartstock/core/components/input_error_message.dart';
import 'package:smartstock/core/helpers/util.dart';

class ChoicesInput extends StatefulWidget {
  final String comparisonKey;
  final Function(dynamic) onChoice;
  final dynamic choice;
  final Future Function({bool skipLocal}) onLoad;
  final Widget Function()? getAddWidget;
  final String label;
  final String placeholder;
  final String error;
  final Function(dynamic) onField;
  final bool showBorder;
  final bool multiple;

  const ChoicesInput({
    super.key,
    required this.onChoice,
    this.comparisonKey='id',
    required this.choice,
    required this.onLoad,
    this.getAddWidget,
    this.label = '',
    this.placeholder = '',
    this.error = '',
    this.showBorder = true,
    this.multiple = false,
    required this.onField,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ChoicesInput> {

  @override
  void initState() {
    super.initState();
  }


  Widget _getFullWidthText() {
    return Expanded(
      child: SizedBox(
        height: 46,
        child: InkWell(
          onTap: () {
            _showDialogForChoiceSelection(
              context: context,
              onChoice: (value) {
                widget.onChoice(value);
                Navigator.of(context).maybePop();
              },
              onField: widget.onField,
            );
          },
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: BodyLarge(
                text: widget.choice is List
                    ? widget.choice.map(widget.onField).join(',')
                    : widget.onField(widget.choice)),
          ),
        ),
      ),
    );
  }

  Widget _getLabel(label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: LabelMedium(text: label),
    );
  }

  _actionsItems(onText, getAddWidget, onField, BuildContext context) {
    return IconButton(
        onPressed: () => _showDialogForChoiceSelection(
            context: context, onChoice: onText, onField: onField),
        icon: const Icon(Icons.arrow_drop_down));
  }

  _actions(onText, onAdd, onField) =>
      _actionsItems(onText, onAdd, onField, context);

  _showDialogForChoiceSelection({
    required BuildContext context,
    required Function(dynamic value) onChoice,
    required Function(dynamic value) onField,
  }) {
    return !getIsSmallScreen(context)
        ? showDialog(
            context: context,
            builder: (_) {
              return Dialog(
                backgroundColor: Theme.of(context).colorScheme.surface,
                surfaceTintColor: Colors.transparent,
                child: DialogContentWrapper(
                  child: ChoiceInputDropdown(
                    comparisonKey: widget.comparisonKey,
                    choice: widget.choice,
                    onCreateBuilder: widget.getAddWidget,
                    onTitle: onField,
                    onChoice: onChoice,
                    multiple: widget.multiple,
                    label: widget.label,
                    onLoadDataFuture: widget.onLoad,
                  ),
                ),
              );
            },
          )
        : showFullScreeDialog(
            context,
            (p0) => Scaffold(
              appBar: AppBar(
                title: BodyLarge(
                    text: widget.label
                        .split(' ')
                        .map((e) => firstLetterUpperCase(e))
                        .join(' ')),
              ),
              backgroundColor: Theme.of(context).colorScheme.surface,
              body: ChoiceInputDropdown(
                comparisonKey: widget.comparisonKey,
                choice: widget.choice,
                onCreateBuilder: widget.getAddWidget,
                onTitle: onField,
                onChoice: onChoice,
                multiple: widget.multiple,
                label: widget.label,
                onLoadDataFuture: widget.onLoad,
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      widget.label.isNotEmpty
          ? _getLabel(widget.label)
          : const SizedBox(height: 0),
      Container(
        decoration: widget.showBorder
            ? getInputBoxDecoration(context, widget.error)
            : null,
        child: Row(
          children: [
            _getFullWidthText(),
            _actions(widget.onChoice, widget.getAddWidget, widget.onField)
          ],
        ),
      ),
      inputErrorMessageOrEmpty(widget.error)
    ]);
  }
}
