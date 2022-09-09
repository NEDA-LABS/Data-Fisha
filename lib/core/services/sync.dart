import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:smartstock/core/services/cache_sync.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:workmanager/workmanager.dart';

var shouldRun = true;
var syncsTaskId = 'syncs_local_data';

void syncCallbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (kDebugMode) {
      print(task);
    }
    if (task == '$syncsTaskId-period' || task == '$syncsTaskId-onetime') {
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
  // if (kDebugMode) {
    print('------syncs routine run------');
  // }
  List keys = await getLocalSyncsKeys();
  // print(keys);
  for (var key in keys) {
    var element = await getLocalSync(key);
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

oneTimeLocalSyncs() async {
  if (isNativeMobilePlatform()) {
    Workmanager().registerOneOffTask(
        '$syncsTaskId-onetime', '$syncsTaskId-onetime',
        existingWorkPolicy: ExistingWorkPolicy.append,
        constraints: Constraints(networkType: NetworkType.connected));
  }
}

periodicLocalSyncs() async {
  if (isNativeMobilePlatform()) {
    if (kDebugMode) {
      print("::::: native mobile");
    }
    Workmanager().initialize(syncCallbackDispatcher, isInDebugMode: kDebugMode);
    Workmanager().registerPeriodicTask(
      '$syncsTaskId-period',
      '$syncsTaskId-period',
      existingWorkPolicy: ExistingWorkPolicy.replace,
      constraints: Constraints(networkType: NetworkType.connected),
    );
  } else {
    // if (kDebugMode) {
      print("::::: others");
    // }
    Timer.periodic(const Duration(seconds: 8), (_) async {
      if (shouldRun) {
        shouldRun = false;
        compute(syncLocal2Remote, 2).catchError((_) {
          // if (kDebugMode) {
            print(_);
          // }
        }).then((value) {
          // if (kDebugMode) {
            print('done sync local data --> $value');
          // }
        }).whenComplete(() {
          shouldRun = true;
        });
      } else {
        // if (kDebugMode) {
          print('another save sales routine runs');
        // }
      }
    });
  }
}
