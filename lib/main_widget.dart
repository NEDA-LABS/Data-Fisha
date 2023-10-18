import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/helpers/configs.dart';
import 'package:smartstock/core/services/util.dart';

import 'smartstock.dart';

class MainWidget extends StatefulWidget {
  final OnGetModulesMenu onGetModulesMenu;
  final OnGetInitialPage onGetInitialModule;

  const MainWidget({
    super.key,
    required this.onGetModulesMenu,
    required this.onGetInitialModule,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<MainWidget> {
  @override
  Widget build(BuildContext context) {
    var lightTheme = ThemeData(
        colorScheme: lightColorScheme, fontFamily: 'Inter', useMaterial3: true);
    var darkTheme = ThemeData(
        colorScheme: darkColorScheme, fontFamily: 'Inter', useMaterial3: true);
    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child ?? Container(),
        );
      },
      debugShowCheckedModeBanner: kDebugMode,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: SafeArea(
        child: SmartStock(
          onGetModulesMenu: widget.onGetModulesMenu,
          onGetInitialModule: widget.onGetInitialModule,
        ),
      ),
    );
  }
}
