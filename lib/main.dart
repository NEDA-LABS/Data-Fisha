import 'dart:io';

import 'package:builders/builders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/configurations.dart';
import 'package:smartstock/core/services/http_overrider.dart';
import 'package:smartstock/core/services/sync.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  periodicLocalSyncs();
  HttpOverrides.global = MyHttpOverrides();
  Builders.systemInjector(Modular.get);
  runApp(
    ModularApp(
      module: AppModule(),
      child: MaterialApp.router(
        routeInformationParser: Modular.routeInformationParser,
        routerDelegate: Modular.routerDelegate,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: getSmartStockMaterialColorSwatch(),
        ),
      ),
    ),
  );
}

