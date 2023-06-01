import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/configs.dart';
import 'package:smartstock/core/plugins/sync.dart';
import 'package:smartstock/core/plugins/sync_common.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == 'bg-period' || task == 'bg-onetime') {
      try {
        await syncLocalDataToRemoteServer();
        return Future.value(true);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        rethrow;
      }
    } else {
      return Future.value(true);
    }
  });
}

startSmartStock({required OnGetModulesMenu onGetModulesMenu}) {
  WidgetsFlutterBinding.ensureInitialized();
  periodicLocalDataSyncs(callbackDispatcher);
  runApp(_MainWidget(onGetModulesMenu: onGetModulesMenu));
}

class _MainWidget extends StatefulWidget {
  final OnGetModulesMenu onGetModulesMenu;

  const _MainWidget({required this.onGetModulesMenu}) : super();

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<_MainWidget> {
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
      home: SmartStockApp(onGetModulesMenu: widget.onGetModulesMenu),
    );
  }
}
