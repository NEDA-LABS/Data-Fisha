import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:builders/builders.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/configurations.dart';
import 'package:smartstock/core/services/cache_sync.dart';
import 'package:smartstock/core/services/http_overrider.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:workmanager/workmanager.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: kDebugMode);
  periodicLocalSyncs();

  Builders.systemInjector(Modular.get);
  runApp(ModularApp(module: AppModule(), child: mainWidget()));
}

mainWidget() => MaterialApp.router(
    routeInformationParser: Modular.routeInformationParser,
    routerDelegate: Modular.routerDelegate,
    debugShowCheckedModeBanner: kDebugMode,
    theme: ThemeData(primarySwatch: getSmartStockMaterialColorSwatch()));

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (kDebugMode) {
      print(task);
    }
    if (task == 'bg-period' || task == 'bg-onetime') {
      try {
        await syncLocal2Remote(1);
        return Future.value(true);
      } catch (e) {
        print(e);
        return Future.value(false);
      }
    }
    return Future.value(true);
  });
}

Future syncLocal2Remote(dynamic) async {
  if (kDebugMode) {
    print('------syncs routine run------');
  }
  List keys = [];//  await getLocalSyncsKeys();
  // print(keys);
  for (var key in keys) {
    var element = null; // await getLocalSync(key);
    var getUrl = propertyOr('url', (p0) => '');
    var getPayload = propertyOr('payload', (p0) => {});
    // print(getUrl(element));
    // print(getPayload(element).length);
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

var shouldRun = true;
periodicLocalSyncs() async {
  if (isNativeMobilePlatform()) {
    if (kDebugMode) {
      print("::::: native mobile");
    }
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
    Timer.periodic(const Duration(seconds: 8), (_) async {
      if (shouldRun) {
        shouldRun = false;
        compute(syncLocal2Remote, 2).catchError((_) {
          if (kDebugMode) {
            print(_);
          }
        }).then((value) {
          if (kDebugMode) {
            print('done sync local data --> $value');
          }
        }).whenComplete(() {
          shouldRun = true;
        });
      } else {
        if (kDebugMode) {
          print('another save sales routine runs');
        }
      }
    });
  }
}
