import 'package:flutter/material.dart';

typedef OnSetContent = Widget Function(StateSetter setState);

Future showFullScreeDialog(context, OnSetContent setContent) {
  return Navigator.of(context).push(MaterialPageRoute<void>(
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            elevation: 0,
            insetPadding: const EdgeInsets.all(0),
            child: setContent(setState),
          );
        },
      );
    },
    fullscreenDialog: true,
  ));
}
