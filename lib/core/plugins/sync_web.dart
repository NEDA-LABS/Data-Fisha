import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:smartstock/core/plugins/sync_common.dart';

var _shouldRun = true;
// var _shouldSubsRun = true;

Future _pushDataToServer(dynamic v) async {
  return await syncLocalDataToRemoteServer();
}

// Future _checkSubscription(dynamic v) async {
//   return await syncSubscriptionFromRemoteServer();
// }

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

// periodicSubscription({required Function(dynamic subs) onSubscription}) async {
//   Timer.periodic(const Duration(minutes: 5), (_) async {
//     if (_shouldSubsRun) {
//       _shouldSubsRun = false;
//       compute(_checkSubscription, '').then((value) {
//         if (kDebugMode) {
//           print('Subscription: $value');
//         }
//         onSubscription(value);
//       }).catchError((_) {
//         if (kDebugMode) {
//           print(_);
//         }
//       }).whenComplete(() {
//         _shouldSubsRun = true;
//       });
//     } else {
//       if (kDebugMode) {
//         print('another subscription sync running');
//       }
//     }
//   });
// }
