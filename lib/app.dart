import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock_pos/account/account.dart';
import 'package:smartstock_pos/core/guards/auth.dart';
import 'package:smartstock_pos/stocks/services/navigation.dart';
import 'package:smartstock_pos/stocks/stocks.dart';

import '../sales/sales.dart';
import 'core/models/menu.dart';
import 'sales/services/navigation.dart';

class AppModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ModuleRoute('/', module: AccountModule()),
        ModuleRoute('/sales/', guards: [AuthGuard()], module: SalesModule()),
        ModuleRoute('/stock/', guards: [AuthGuard()], module: StockModule()),
      ];

  @override
  List<Bind> get binds => [];
}

List<MenuModel> moduleMenus() => [salesMenu(), stocksMenu()];
