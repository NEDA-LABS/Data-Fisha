import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';

class PrimaryAction extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const PrimaryAction({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all<Size>(const Size.fromHeight(48)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))
          )
        ),
        backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.primary),
        overlayColor: MaterialStateProperty.all<Color>(const Color(0x3d000000)),
        foregroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.onPrimary),
      ),
      child: FittedBox(fit: BoxFit.scaleDown, child: BodyLarge(text: text)),
    );
  }
}
