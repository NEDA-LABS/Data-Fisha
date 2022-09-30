import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock/account/account.dart';
import 'package:smartstock/core/guards/auth.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/dashboard/dashboard.dart';
import 'package:smartstock/dashboard/services/navigation.dart';
import 'package:smartstock/sales/guards/active_shop.dart';
import 'package:smartstock/sales/sales.dart';
import 'package:smartstock/sales/services/navigation.dart';
import 'package:smartstock/stocks/services/navigation.dart';
import 'package:smartstock/stocks/stocks.dart';

class AppModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ModuleRoute(
          '/',
          guards: [AuthGuard(), ActiveShopGuard()],
          module: DashboardModule(),
        ),
        ModuleRoute('/account/', module: AccountModule()),
        ModuleRoute(
          '/dashboard/',
          guards: [AuthGuard(), ActiveShopGuard()],
          module: DashboardModule(),
        ),
        ModuleRoute('/sales/', guards: [AuthGuard()], module: SalesModule()),
        ModuleRoute('/stock/', guards: [AuthGuard()], module: StockModule()),
      ];

  @override
  List<Bind> get binds => [];
}

List<MenuModel> moduleMenus() {
  return [
    dashboardMenu(),
    salesMenu(),
    stocksMenu(),
  ];
}
