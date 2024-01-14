import 'package:flutter/material.dart';
import 'package:smartstock/core/helpers/functional.dart';

var inputErrorMessageOrEmpty = ifDoElse(
    (x) => x is String && x.isNotEmpty,
    (x) => Padding(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
        child:
            Text(x, style: const TextStyle(fontSize: 14, color: Colors.red))),
    (_) => const SizedBox());
