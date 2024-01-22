import 'package:flutter/material.dart';
import 'package:smartstock/core/components/delete_dialog.dart';

showDeleteDialogHelper({
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
