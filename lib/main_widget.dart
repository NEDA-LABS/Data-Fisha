import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/helpers/configs.dart';
import 'package:smartstock/core/helpers/util.dart';

import 'chatafisha.dart';

class MainWidget extends StatefulWidget {
  final OnGeAppMenu onGetModulesMenu;
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
    var lightTheme =
        ThemeData(colorScheme: lightColorScheme, fontFamily: 'Syne');
    var darkTheme =
        ThemeData(colorScheme: darkColorScheme, fontFamily: 'Syne');
    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
          child: child ?? Container(),
        );
      },
      debugShowCheckedModeBanner: kDebugMode,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: SafeArea(
        child: SmartStock(
          onGetModulesMenu: widget.onGetModulesMenu,
          onGetInitialPage: widget.onGetInitialModule,
        ),
      ),
    );
  }
}
