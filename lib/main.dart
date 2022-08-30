import 'dart:io';
import 'package:builders/builders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'app.dart';
import 'configurations.dart';
import 'sales/services/sales_sync.dart';
import 'sales/services/stocks.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() async {
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
  SalesSyncService().start();
  StockSyncService.run();
}
