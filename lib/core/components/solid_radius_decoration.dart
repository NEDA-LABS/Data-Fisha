import 'package:flutter/material.dart';

solidRadiusBoxDecoration(BuildContext context) => BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceVariant,
      borderRadius: BorderRadius.circular(8),
      // border: Border.all(color: const Color(0xffe1e1e1), width: .8),
    );
