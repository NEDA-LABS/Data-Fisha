import 'package:flutter/material.dart';
import 'package:smartstock/core/helpers/configs.dart';

raisedButton({
  Function? onPressed,
  required String title,
  double height = 34,
  Color textColor = const Color(0xffffffff),
}) {
  return Container(
    height: height,
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: Builder(builder: (context) {
      return OutlinedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
          overlayColor: MaterialStateProperty.all<Color>(primaryBaseLightColor),
        ),
        onPressed: onPressed as void Function()?,
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: textColor,
            fontSize: 16,
          ),
        ),
      );
    }),
  );
}

outlineActionButton(
    {Function? onPressed, required String title, Color? textColor}) {
  return Container(
    height: 34,
    margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8, left: 0),
    child: OutlinedButton(
      // style: ButtonStyle(
      //   backgroundColor: MaterialStateProperty.all<Color>(
      //     primaryBaseLightColor,
      //   ),
      // ),
      onPressed: onPressed as void Function()?,
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          // color: textColor ?? primaryBaseColorValue,
          fontSize: 16,
        ),
      ),
    ),
  );
}
