import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock/account/account.dart';
import 'package:smartstock/core/guards/auth.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/sales/sales.dart';
import 'package:smartstock/sales/services/navigation.dart';
import 'package:smartstock/stocks/services/navigation.dart';
import 'package:smartstock/stocks/stocks.dart';

class AppModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ModuleRoute('/', module: AccountModule()),
        ModuleRoute('/account/', module: AccountModule()),
        ModuleRoute('/sales/', guards: [AuthGuard()], module: SalesModule()),
        ModuleRoute('/stock/', guards: [AuthGuard()], module: StockModule()),
      ];

  @override
  List<Bind> get binds => [];
}

List<MenuModel> moduleMenus() => [salesMenu(), stocksMenu()];
