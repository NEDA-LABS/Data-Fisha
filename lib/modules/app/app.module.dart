import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock_pos/modules/sales/sales.module.dart';
import 'package:smartstock_pos/modules/shop/shop.module.dart';

import 'pages/login.page.dart';
import 'states/login.state.dart';

class AppModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute('/login', child: (_, __) => LoginPage()),
        ModuleRoute('/sales', module: SalesModule()),
        ModuleRoute('/shop', module: ShopModule())
      ];

  @override
  List<Bind> get binds => [Bind.lazySingleton((i) => LoginPageState())];
}
