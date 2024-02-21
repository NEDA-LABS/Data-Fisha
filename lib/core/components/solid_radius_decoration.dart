import 'package:flutter/material.dart';

solidRadiusBoxDecoration(BuildContext context) => BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceVariant,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Theme.of(context).colorScheme.primaryContainer, width: 1),
    );
