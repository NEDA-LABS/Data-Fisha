import 'package:flutter/material.dart';
import 'package:smartstock/core/services/util.dart';

_bar(context) => Padding(
    padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
    child: Center(
        child: Container(
            height: 8,
            width: 80,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColorDark,
                borderRadius: const BorderRadius.all(Radius.circular(80))))));

showDialogOrModalSheet(Widget content, context) => hasEnoughWidth(context)
    ? showDialog(
        context: context,
        builder: (_) => Dialog(
            child: Container(
                constraints: const BoxConstraints(
                    maxWidth: 600, minHeight: 300, maxHeight: 600),
                child: content
                // Column(children: [
                //   _bar(context),
                //   Expanded(child: SingleChildScrollView(child: content))
                // ])
            )))
    : showModalBottomSheet(
        // isScrollControlled: true,
        context: context,
        builder: (_) => Column(children: [
              _bar(context),
              Expanded(child: SingleChildScrollView(child: content))
            ]));
