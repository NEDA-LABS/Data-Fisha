import 'package:flutter/material.dart';

_contextButton({@required String text, @required Function pressed}) => Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: OutlinedButton(onPressed: pressed, child: Text(text)),
    );

tableContextMenu(totalItems) => SizedBox(
      height: 62,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 14),
        child: Row(
          children: [
            _contextButton(pressed: () {}, text: 'Reload'),
            _contextButton(pressed: () {}, text: 'Import'),
            _contextButton(pressed: () {}, text: 'Export'),
            Expanded(flex: 1, child: Container()),
            Text('Total : $totalItems')
          ],
        ),
      ),
    );
