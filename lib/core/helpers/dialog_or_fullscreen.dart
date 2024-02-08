import 'package:flutter/material.dart';
import 'package:smartstock/core/components/full_screen_dialog.dart';
import 'package:smartstock/core/helpers/dialog.dart';
import 'package:smartstock/core/helpers/util.dart';

showDialogOrFullScreenModal(Widget content, context) {
  dialog() {
    return showDialog(
      context: context,
      builder: (_) {
        return getDialogLarge(context, content);
      },
    );
  }

  fullscreen() {
    return showFullScreeDialog(
      context,
      (setState) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(),
        body: content,
      ),
    );
  }

  return hasEnoughWidth(context) ? dialog() : fullscreen();
}
