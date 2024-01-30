import 'package:flutter/material.dart';
import 'package:smartstock/core/helpers/dialog.dart';
import 'package:smartstock/core/helpers/util.dart';

showDialogOrModalSheet(Widget content, context) {
  dialog()=>showDialog(
    context: context,
    builder: (_) {
      return getDialogLarge(context, content);
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
