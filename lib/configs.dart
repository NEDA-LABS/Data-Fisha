import 'package:bfast/options.dart';
import 'package:flutter/material.dart';

// GREEN : 0xFF0b2e13
// class Config{
// const primaryColor = Color(0xffffd200);

// BLUE : #005aa9
// ORANGE : #e27739

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF0E5FAE),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFD5E3FF),
  onPrimaryContainer: Color(0xFF001C3B),
  secondary: Color(0xFF9D4303),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFFFDBCB),
  onSecondaryContainer: Color(0xFF341100),
  tertiary: Color(0xFF0E5FAE),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFD5E3FF),
  onTertiaryContainer: Color(0xFF001C3B),
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  background: Color(0xFFFDFBFF),
  onBackground: Color(0xFF1A1C1E),
  surface: Color(0xFFFDFBFF),
  onSurface: Color(0xFF1A1C1E),
  surfaceVariant: Color(0xFFE0E2EC),
  onSurfaceVariant: Color(0xFF43474E),
  outline: Color(0xFF74777F),
  onInverseSurface: Color(0xFFF1F0F4),
  inverseSurface: Color(0xFF2F3033),
  inversePrimary: Color(0xFFA6C8FF),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF0E5FAE),
  outlineVariant: Color(0xFFC4C6CF),
  scrim: Color(0xFF000000),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFA6C8FF),
  onPrimary: Color(0xFF003060),
  primaryContainer: Color(0xFF004787),
  onPrimaryContainer: Color(0xFFD5E3FF),
  secondary: Color(0xFFFFB691),
  onSecondary: Color(0xFF552100),
  secondaryContainer: Color(0xFF783100),
  onSecondaryContainer: Color(0xFFFFDBCB),
  tertiary: Color(0xFFA6C8FF),
  onTertiary: Color(0xFF003060),
  tertiaryContainer: Color(0xFF004787),
  onTertiaryContainer: Color(0xFFD5E3FF),
  error: Color(0xFFFFB4AB),
  errorContainer: Color(0xFF93000A),
  onError: Color(0xFF690005),
  onErrorContainer: Color(0xFFFFDAD6),
  background: Color(0xFF1A1C1E),
  onBackground: Color(0xFFE3E2E6),
  surface: Color(0xFF1A1C1E),
  onSurface: Color(0xFFE3E2E6),
  surfaceVariant: Color(0xFF43474E),
  onSurfaceVariant: Color(0xFFC4C6CF),
  outline: Color(0xFF8D9199),
  onInverseSurface: Color(0xFF1A1C1E),
  inverseSurface: Color(0xFFE3E2E6),
  inversePrimary: Color(0xFF0E5FAE),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFFA6C8FF),
  outlineVariant: Color(0xFF43474E),
  scrim: Color(0xFF000000),
);

// blue 0xff0049a9
var criticalColor = const Color(0xFFFF0000);
var healthColor = const Color(0xFF4AA785);
var primaryBaseColorValue = const Color(0xff005aa9);
var primaryBaseLightColor = const Color(0x1a005aa9);

App smartStockApp =
    App(applicationId: 'smartstock_lb', projectId: 'smartstock');

getVendorName(){
  return 'SMARTSTOCK';
}
getVendorCost() {
  return 10000;
}

String version = "1.4.1-2023.10.5-b.0";
