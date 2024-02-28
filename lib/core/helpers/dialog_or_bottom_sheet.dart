import 'package:flutter/material.dart';
import 'package:smartstock/core/helpers/dialog.dart';
import 'package:smartstock/core/helpers/util.dart';

showDialogOrModalSheet(Widget content, context,{bool canDismiss=true}) {
  dialog(){
    return showDialog(
      context: context,
      barrierDismissible: canDismiss,
      builder: (_) {
        return getDialogLarge(context, content);
      },
    );
  }
  sheet(){
    return showModalBottomSheet(
      context: context,
      isDismissible: canDismiss,
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
  }
  return hasEnoughWidth(context) ? dialog() : sheet();
}
