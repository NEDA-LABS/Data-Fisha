import 'package:flutter/material.dart';
import 'package:smartstock/core/components/button.dart';
import 'package:smartstock/core/services/util.dart';

showInfoDialog(context, err, {title = 'Info'}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Text('$err'),
        ),
        actions: [
          outlineActionButton(
              title: 'Ok',
              onPressed: () {
                navigator().maybePop();
              })
        ],
      );
    },
  );
}
