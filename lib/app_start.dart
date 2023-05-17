import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:builders/builders.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/color_schemes.dart';
import 'package:smartstock/core/pages/FeatureModule.dart';
import 'package:smartstock/core/services/cache_sync.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    if (task == 'bg-period' || task == 'bg-onetime') {
      try {
        _syncLocal2Remote(null).then((value) => Future.value(true));
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        // rethrow;
      }
    }
    return Future.value(true);
  });
}

startSmartStock({
  required OnGetModulesMenu onGetModulesMenu,
  required Map<String, Module Function(OnGetModulesMenu)> coreModules,
  required Map<String, FeatureModule Function(OnGetModulesMenu)> featureModules,
}) {
  WidgetsFlutterBinding.ensureInitialized();
  _periodicLocalSyncs();
  Builders.systemInjector(Modular.get);
  runApp(
    ModularApp(
      module: SmartStockCoreModule(
        onGetModulesMenu: onGetModulesMenu,
        coreModules: coreModules,
        featureModules: featureModules,
      ),
      child: _mainWidget(),
    ),
  );
}

_mainWidget() {
  return MaterialApp.router(
    routeInformationParser: Modular.routeInformationParser,
    routerDelegate: Modular.routerDelegate,
    debugShowCheckedModeBanner: kDebugMode,
    theme: ThemeData(
        colorScheme: lightColorScheme, fontFamily: 'Inter', useMaterial3: true),
    darkTheme: ThemeData(
      colorScheme: darkColorScheme,
      fontFamily: 'Inter',
      useMaterial3: true,
    ),
  );
}

Future _syncLocal2Remote(RootIsolateToken? rootIsolateToken) async {
  if (rootIsolateToken != null) {
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
  }
  List keys = await getLocalSyncsKeys();
  if (kDebugMode) {
    print('Data to sync: ${keys.length}');
  }
  for (var key in keys) {
    var element = await getLocalSync(key);
    var getUrl = propertyOr('url', (p0) => '');
    var getPayload = propertyOr('payload', (p0) => {});
    var response = await post(Uri.parse(getUrl(element)),
        headers: {'content-type': 'application/json'},
        body: jsonEncode(getPayload(element)));
    if (response.statusCode == 200) {
      await removeLocalSync(key);
      return key;
    } else {
      throw response.body;
    }
  }
}

var _shouldRun = true;

_periodicLocalSyncs() async {
  var isAndroid = !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  if (isAndroid) {
    if (kDebugMode) {
      print("::::: native mobile");
    }
    Workmanager().initialize(callbackDispatcher, isInDebugMode: kDebugMode);
    Workmanager().registerPeriodicTask(
      'bg-period',
      'bg-period',
      existingWorkPolicy: ExistingWorkPolicy.replace,
      constraints: Constraints(networkType: NetworkType.connected),
    );
  } else {
    if (kDebugMode) {
      print("::::: others");
    }
    Timer.periodic(const Duration(seconds: 15), (_) async {
      if (_shouldRun) {
        _shouldRun = false;
        // compute(_syncLocal2Remote, 2)
        Isolate.spawn(_syncLocal2Remote, ServicesBinding.rootIsolateToken)
            .then((value) {
          if (kDebugMode) {
            print('done sync local data');
          }
        }).catchError((_) {
          if (kDebugMode) {
            print(_);
          }
        }).whenComplete(() {
          _shouldRun = true;
        });
      } else {
        if (kDebugMode) {
          print('another save sales routine runs');
        }
      }
    });
  }
}
