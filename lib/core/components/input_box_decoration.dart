import 'package:flutter/material.dart';

_boxBorder(error, context) => Border.all(
      color: error is String && error.isNotEmpty
          ? Colors.red
          : Theme.of(context).colorScheme.primary,
      width: .8,
    );

_boxRadius() => const BorderRadius.all(Radius.circular(3));

inputBoxDecoration(BuildContext context, String? error) => BoxDecoration(
    // color: Colors.white,
    border: _boxBorder(error, context),
    borderRadius: _boxRadius());
