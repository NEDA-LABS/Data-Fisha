import 'package:flutter/material.dart';

fullScreeDialog(context, Widget Function(dynamic) setContent) {
  Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (context, setState) => Dialog(
                elevation: 0,
                insetPadding: const EdgeInsets.all(0),
                child: setContent(setState)));
      },
      fullscreenDialog: true));
}
