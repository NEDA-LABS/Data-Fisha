import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/BodyMedium.dart';
import 'package:smartstock/core/components/DisplayTextMedium.dart';
import 'package:smartstock/core/components/DisplayTextSmall.dart';
import 'package:smartstock/core/components/HeadineSmall.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/button.dart';
import 'package:smartstock/core/services/util.dart';

Future showInfoDialog(context, message, {title = 'Info'}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info, color: Theme.of(context).colorScheme.error),
            const WhiteSpacer(width: 8),
            BodyLarge(text: title)
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Center(child: BodyMedium(text: '$message')),
            ),
            const WhiteSpacer(height: 16),
            outlineActionButton(
              title: 'Close',
              onPressed: () {
                Navigator.of(context).maybePop();
              },
            )
          ],
        ),
      );
    },
  );
}
