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

// raisedButton({
//   Function? onPressed,
//   required String title,
//   double height = 34,
//   Color textColor = const Color(0xffffffff),
// }) {
//   return Container(
//     height: height,
//     margin: const EdgeInsets.symmetric(vertical: 8),
//     child: Builder(builder: (context) {
//       return OutlinedButton(
//         style: ButtonStyle(
//           backgroundColor:
//               MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
//           overlayColor: MaterialStateProperty.all<Color>(primaryBaseLightColor),
//         ),
//         onPressed: onPressed as void Function()?,
//         child: Text(
//           title,
//           style: TextStyle(
//             fontWeight: FontWeight.w500,
//             color: textColor,
//             fontSize: 16,
//           ),
//         ),
//       );
//     }),
//   );
// }
