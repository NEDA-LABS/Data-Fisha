import 'dart:async';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:smartstock/core/plugins/sync_common.dart';
import 'package:workmanager/workmanager.dart';

var _shouldRun = true;

Future _pushDataToServer(RootIsolateToken? rootIsolateToken) async {
  if (rootIsolateToken != null) {
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
  }
  return await syncLocalDataToRemoteServer();
}

periodicLocalDataSyncs(Function() callbackDispatcher) async {
  var isAndroid = !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  if (isAndroid) {
    if (kDebugMode) {
      print("::::: native android mobile");
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
    Timer.periodic(const Duration(seconds: 5), (_) async {
      if (_shouldRun) {
        _shouldRun = false;
        Isolate.spawn(_pushDataToServer, ServicesBinding.rootIsolateToken)
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

Future<dynamic> checkSubscription(List<dynamic> args) async {
  BackgroundIsolateBinaryMessenger.ensureInitialized(args[1]);
  var r = await syncSubscriptionFromRemoteServer();
  Isolate.exit(args[0], r);
}