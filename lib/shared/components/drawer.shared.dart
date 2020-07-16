import 'package:bfastui/bfastui.dart';
import 'package:flutter/material.dart';

class DrawerComponents {
  Widget get drawer {
    return BFastUI.component().custom(
      (context) => Column(
        children: [Text("Dashboard")],
      ),
    );
  }
}
