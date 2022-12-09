import 'package:bfast/options.dart';
import 'package:flutter/material.dart';

// GREEN : 0xFF0b2e13
// class Config{
// const primaryColor = Color(0xffffd200);

// NMB BLUE : #005aa9
// NMB ORANGE : #e27739


// blue 0xff0049a9
var primaryBaseColorValue = const Color(0xff005aa9);
var primaryBaseLightColor = const Color(0x1a005aa9);
MaterialColor getSmartStockMaterialColorSwatch() {
  Color color = primaryBaseColorValue;
  List strengths = <double>[.05];
  Map<int, Color> swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}
// }


App smartstockApp =
    App(applicationId: 'smartstock_lb', projectId: 'smartstock');

String version = "1.0.5-d.2022.12.9-b.6";