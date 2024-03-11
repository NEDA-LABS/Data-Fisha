import 'package:flutter/cupertino.dart';

class SurfaceWithImage extends StatelessWidget {
  final Widget child;
  final double childMaxWidth;

  const SurfaceWithImage(
      {super.key, required this.child, this.childMaxWidth = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/surface-bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child:
      // childMaxWidth > 0
      //     ? Center(
      //         child: Container(
      //             constraints: BoxConstraints(maxWidth: childMaxWidth)),
      //       )
      //     :
      child /* add child content here */,
    );
  }
}
