import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';

class PrimaryAction extends StatelessWidget {
  final Color? color;
  final Widget? leading;
  final bool disabled;
  final String text;
  final VoidCallback? onPressed;

  const PrimaryAction({super.key, required this.text, required this.onPressed, this.disabled=false, this.color,  this.leading});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: disabled?null:onPressed,
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all<Size>(const Size.fromHeight(48)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))
          )
        ),
        backgroundColor: MaterialStateProperty.all<Color>(color??Theme.of(context).colorScheme.primary),
        overlayColor: MaterialStateProperty.all<Color>(const Color(0x3d000000)),
        foregroundColor: MaterialStateProperty.all<Color>(color!=null?Colors.white:Theme.of(context).colorScheme.onPrimary),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(fit: BoxFit.scaleDown, child: BodyLarge(text: text)),
          WhiteSpacer(width: leading!=null?8:0),
          leading??Container()
        ],
      ),
    );
  }
}
