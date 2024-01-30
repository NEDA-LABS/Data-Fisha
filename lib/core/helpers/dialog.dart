import 'package:flutter/material.dart';
import 'package:smartstock/core/components/delete_dialog.dart';

showDialogDelete({
  required BuildContext context,
  required name,
  required Future Function() onDelete,
  required Function(dynamic) onDone,
}) {
  showDialog(
    context: context,
    builder: (_) {
      return DeleteDialog(
        onDone: onDone,
        message: 'Delete of $name is permanent, do you wish to continue ? ',
        onConfirm: () => onDelete(),
      );
    },
  );
}

getDialogLarge(BuildContext context, Widget content){
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
}