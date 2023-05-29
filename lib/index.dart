import 'dart:async';

import 'package:builders/builders.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
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

startSmartStock({
  required OnGetModulesMenu onGetModulesMenu,
  required Map<String, Module Function(OnGetModulesMenu)> coreModules,
  // required Map<String, FeatureModule Function(OnGetModulesMenu)> featureModules,
}) {
  WidgetsFlutterBinding.ensureInitialized();
  periodicLocalDataSyncs(callbackDispatcher);
  // Builders.systemInjector(Modular.get);
  // var coreModule = SmartStockCoreModule(
  //   onGetModulesMenu: onGetModulesMenu,
  //   coreModules: coreModules,
  // //   featureModules: featureModules,
  // );
  runApp(_mainWidget(onGetModulesMenu));
}

Widget _mainWidget(OnGetModulesMenu onGetModulesMenu) {
  var lightTheme = ThemeData(
      colorScheme: lightColorScheme, fontFamily: 'Inter', useMaterial3: true);
  var darkTheme = ThemeData(
      colorScheme: darkColorScheme, fontFamily: 'Inter', useMaterial3: true);
  return MaterialApp(
    // routeInformationParser: Modular.routeInformationParser,
    // routerDelegate: Modular.routerDelegate,
    debugShowCheckedModeBanner: kDebugMode,
    theme: lightTheme,
    darkTheme: darkTheme,
    home: SmartStockApp(onGetModulesMenu: onGetModulesMenu),
  );
}
