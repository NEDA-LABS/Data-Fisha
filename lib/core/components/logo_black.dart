import 'package:flutter/material.dart';

class LogoBlack extends StatelessWidget {
  final double size;

  const LogoBlack({super.key, this.size = 50});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/logo-black.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: null /* add child content here */,
    );
  }
}
