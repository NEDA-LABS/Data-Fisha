import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock/account/account.dart';
import 'package:smartstock/account/services/navigation.dart';
import 'package:smartstock/core/guards/auth.dart';
import 'package:smartstock/core/guards/manager.dart';
import 'package:smartstock/core/guards/owner.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/dashboard/dashboard.dart';
import 'package:smartstock/dashboard/services/navigation.dart';
import 'package:smartstock/expense/index.dart';
import 'package:smartstock/expense/services/navigation.dart';
import 'package:smartstock/report/report.dart';
import 'package:smartstock/report/services/navigation.dart';
import 'package:smartstock/sales/guards/active_shop.dart';
import 'package:smartstock/sales/sales.dart';
import 'package:smartstock/sales/services/navigation.dart';
import 'package:smartstock/stocks/services/navigation.dart';
import 'package:smartstock/stocks/stocks.dart';

class SmartStockCoreModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ModuleRoute(
          '/',
          guards: [AuthGuard(), ActiveShopGuard(), OwnerGuard()],
          module: DashboardModule([]),
        ),
        ModuleRoute(
          '/account/',
          guards: [],
          module: AccountModule([]),
        ),
        ModuleRoute(
          '/dashboard/',
          guards: [AuthGuard(), ActiveShopGuard(), OwnerGuard()],
          module: DashboardModule([]),
        ),
        ModuleRoute(
          '/report/',
          guards: [AuthGuard(), ActiveShopGuard(), OwnerGuard()],
          module: ReportModule([]),
        ),
        ModuleRoute(
          '/sales/',
          guards: [AuthGuard(), ActiveShopGuard()],
          module: SalesModule(),
        ),
        ModuleRoute(
          '/stock/',
          guards: [AuthGuard(), ActiveShopGuard(), ManagerGuard()],
          module: StockModule([]),
        ),
        ModuleRoute(
          '/expense/',
          guards: [AuthGuard(), ActiveShopGuard()],
          module: ExpenseModule([]),
        ),
      ];

  @override
  List<Bind> get binds => [];
}

List<MenuModel> getAppModuleMenus(BuildContext context) {
  return [
    dashboardMenu(context),
    reportMenu(context),
    getSalesModuleMenu(context),
    getStocksModuleMenu(context),
    expenseMenu(context),
    getAccountMenu(context),
  ];
}
