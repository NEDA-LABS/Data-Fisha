import 'package:flutter/material.dart';

import '../services/util.dart';
_bar(context)=> Padding(
  padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
  child: Center(
    child: Container(
      height: 8,
      width: 80,
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColorDark,
          borderRadius:
          const BorderRadius.all(Radius.circular(80))),
    ),
  ),
);
showDialogOrModalSheet(Widget content, context) => hasEnoughWidth(context)
    ? showDialog(
        context: context,
        builder: (_) => Dialog(
            child: Container(
                constraints: const BoxConstraints(
                    maxWidth: 500, minHeight: 200, maxHeight: 300),
                child: Column(
                  children: [
                    _bar(context),
                    Expanded(child: SingleChildScrollView(child: content)),
                  ],
                ))))
    : showModalBottomSheet(
        // isScrollControlled: true,
        context: context,
        builder: (_) => Column(
              children: [
                _bar(context),
                Expanded(child: SingleChildScrollView(child: content)),
              ],
            ));
