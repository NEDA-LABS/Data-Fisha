import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'configurations.dart';
import 'models/shop.dart';
import 'modules/dashboard/dashboardView.dart';
import 'providers/shop_detail_change_notifier.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<ShopDetailsChangeNotifier>(
        create: (_) => ShopDetailsChangeNotifier(),
      )
    ],
    child: SmartStockApp(),
  ));
}

class SmartStockApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // set the shop for the application - should be set after profile selection
    return MaterialApp(
        title: 'SmartStock App',
        theme: ThemeData(
          primarySwatch: Config.getSmartStockMaterialColorSwatch(),
        ),
        home: Scaffold(
          body: Consumer<ShopDetailsChangeNotifier>(
              builder: (context, shopDetailsChangeNotifier, child) {
            shopDetailsChangeNotifier.addShop(
                newShop: Shop(name: "Fish Genge"));
            return DashBoardView();
          }),
        ));
  }
}
