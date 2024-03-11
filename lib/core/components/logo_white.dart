import 'package:flutter/material.dart';

class LogoWhite extends StatelessWidget{
  final double size;
  const LogoWhite({super.key, this.size=50});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/logo-white.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: null /* add child content here */,
    );
  }

}