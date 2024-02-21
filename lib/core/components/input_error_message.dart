import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/LabelLarge.dart';
import 'package:smartstock/core/helpers/functional.dart';

class InputErrorMessageOrEmpty extends StatelessWidget {
  final String error;

  const InputErrorMessageOrEmpty(this.error, {super.key});

  @override
  Widget build(BuildContext context) {
    if (error.isNotEmpty) {
      return Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: LabelLarge(
            text: error,
            color: Theme.of(context).colorScheme.error,
          ));
    } else {
      return const SizedBox();
    }
  }
}
