import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';

class MenuContextAction extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  final Color? textColor;
  final Color? color;
  final double height;

  const MenuContextAction({
    required this.onPressed,
    required this.title,
    this.textColor,
    this.height = 34,
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    var defColor = Theme.of(context).colorScheme.primary;
    return Container(
      height: height,
      margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8, left: 0),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
            side: BorderSide(color: color ?? defColor)),
        child: BodyLarge(text: title, color: textColor),
      ),
    );
  }
}

