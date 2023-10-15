import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/plugins/geolocator_helper.dart';
import 'package:smartstock/core/plugins/sync.dart';
import 'package:smartstock/core/plugins/sync_common.dart';
import 'package:smartstock/core/services/cache_factory.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/main_widget.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void localDataCallbackDispatcher() {
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

initializeSmartStock({
  required OnGetModulesMenu onGetModulesMenu,
  OnGetInitialPage? onGetInitialModule,
}) {
  WidgetsFlutterBinding.ensureInitialized();
  CacheFactory().init();
  ensureGeolocatorWeb();
  periodicLocalDataSyncs(localDataCallbackDispatcher);
  runApp(
    MainWidget(
      onGetModulesMenu: onGetModulesMenu,
      onGetInitialModule: onGetInitialModule ??
          ({required onBackPage, required onChangePage}) => null,
    ),
  );
}
