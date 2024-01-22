import 'package:flutter/material.dart';
import 'package:smartstock/core/helpers/util.dart';

_bar(context) => Padding(
    padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
    child: Center(
        child: Container(
            height: 8,
            width: 80,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColorDark,
                borderRadius: const BorderRadius.all(Radius.circular(80))))));

showDialogOrModalSheet(Widget content, context) {
  dialog()=>showDialog(
    context: context,
    builder: (_) {
      return Dialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 1000,
            minHeight: 200,
            maxHeight: MediaQuery.of(context).size.height - 100,
          ),
          child: content,
        ),
      );
    },
  );
  sheet()=>showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return Container(
        margin: const EdgeInsets.all(16),
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            color: Theme.of(context).colorScheme.surface,
          ),
          child: content,
        ),
      );
    },
  );
  return hasEnoughWidth(context) ? dialog() : sheet();
}
