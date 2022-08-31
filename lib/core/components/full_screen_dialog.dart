import 'package:flutter/material.dart';

fullScreeDialog(context, Widget content) {
  Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          insetPadding: const EdgeInsets.all(0),
          child: content,
        );
      },
      fullscreenDialog: true));
}
