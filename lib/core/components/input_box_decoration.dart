import 'package:flutter/material.dart';

_boxBorder(error, context) => Border.all(
      color: error is String && error.isNotEmpty
          ? Theme.of(context).colorScheme.error
          : Theme.of(context).colorScheme.inversePrimary,
      width: .8,
    );

_boxRadius() => const BorderRadius.all(Radius.circular(8));

getInputBoxDecoration(BuildContext context, String? error, [Color? color]) => BoxDecoration(
    color: color??Theme.of(context).colorScheme.surface,
    border: _boxBorder(error, context),
    borderRadius: _boxRadius());
