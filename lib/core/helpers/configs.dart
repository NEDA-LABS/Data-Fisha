import 'package:flutter/material.dart';
import 'package:smartstock/core/models/App.dart';

// GREEN : 0xFF0b2e13
// class Config{
// const primaryColor = Color(0xffffd200);

// BLUE : #005aa9
// ORANGE : #e27739

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF2BAE0E),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFE9FFD5),
  onPrimaryContainer: Color(0xFF083B00),
  secondary: Color(0xFF039D86),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFCBFFF5),
  onSecondaryContainer: Color(0xFF00342C),
  tertiary: Color(0xFF0E5FAE),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFD5E3FF),
  onTertiaryContainer: Color(0xFF001C3B),
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  background: Color(0xfff0f0f0),
  onBackground: Color(0xFF1A1C1E),
  surface: Color(0xFFFFFFFF),
  onSurface: Color(0xFF1A1C1E),
  surfaceVariant: Color(0xFFFFFFFF),
  onSurfaceVariant: Color(0xFF1A1C1E),
  outline: Color(0xFF74777F),
  onInverseSurface: Color(0xFFF1F0F4),
  inverseSurface: Color(0xFF2F3033),
  inversePrimary: Color(0xFFBCFFA6),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF2BAE0E),
  outlineVariant: Color(0xFFC4C6CF),
  scrim: Color(0xFF000000),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFB9FFA6),
  onPrimary: Color(0xFF156000),
  primaryContainer: Color(0xFF1D8700),
  onPrimaryContainer: Color(0xFFDDFFD5),
  secondary: Color(0xFFFFED91),
  onSecondary: Color(0xFF554700),
  secondaryContainer: Color(0xFF786000),
  onSecondaryContainer: Color(0xFFFFF0CB),
  tertiary: Color(0xFFA6C8FF),
  onTertiary: Color(0xFF003060),
  tertiaryContainer: Color(0xFF004787),
  onTertiaryContainer: Color(0xFFD5E3FF),
  error: Color(0xFFFFB4AB),
  errorContainer: Color(0xFF93000A),
  onError: Color(0xFF690005),
  onErrorContainer: Color(0xFFFFDAD6),
  background: Color(0xFF1C1C1C),
  onBackground: Color(0xFFE3E2E6),
  surface: Color(0xFF181818),
  onSurface: Color(0xFFE3E2E6),
  surfaceVariant: Color(0xFF111111),
  onSurfaceVariant: Color(0xFFC4C6CF),
  outline: Color(0xFF8D9199),
  onInverseSurface: Color(0xFF1A1C1E),
  inverseSurface: Color(0xFFE3E2E6),
  inversePrimary: Color(0xFF4EAE0E),
  shadow: Color(0xFF606060),
  surfaceTint: Color(0xFFB9FFA6),
  outlineVariant: Color(0xFF43474E),
  scrim: Color(0xFF000000),
);

// blue 0xff0049a9
var criticalColor = const Color(0xFFFF0000);
var healthColor = const Color(0xFF4AA785);
var primaryBaseColorValue = const Color(0xff005aa9);
var primaryBaseLightColor = const Color(0x1a005aa9);

App smartStockApp =
    App(applicationId: 'chatafisha', projectId: 'chatafisha');

getVendorName(){
  return 'CHATAFISHA';
}
getVendorCost() {
  return 0;
}

String version = "1.0.0";
