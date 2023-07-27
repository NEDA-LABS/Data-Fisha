import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:smartstock/core/plugins/sync_common.dart';

var _shouldRun = true;

Future _pushDataToServer(dynamic v) async {
  return await syncLocalDataToRemoteServer();
}

periodicLocalDataSyncs(Function() callbackDispatcher) async {
  if (kDebugMode) {
    print("::::: others");
  }
  Timer.periodic(const Duration(seconds: 5), (_) async {
    if (_shouldRun) {
      _shouldRun = false;
      compute(_pushDataToServer, '').then((value) {
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

Future<dynamic> checkSubscription(List<dynamic> args) async {
  return await syncSubscriptionFromRemoteServer();
}
