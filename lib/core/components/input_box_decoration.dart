import 'package:flutter/material.dart';

_boxBorder(error, context) => Border.fromBorderSide(BorderSide(
    color: error is String && error.isNotEmpty
        ? Colors.red
        : Theme.of(context).primaryColorDark));

_boxRadius() => const BorderRadius.all(Radius.circular(3));

inputBoxDecoration(BuildContext context, String error) => BoxDecoration(
    color: Colors.white,
    border: _boxBorder(error, context),
    borderRadius: _boxRadius());