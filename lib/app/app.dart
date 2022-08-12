import 'package:flutter_modular/flutter_modular.dart';

import '../sales/sales.module.dart';
import '../shop/shop.module.dart';
import 'pages/login.dart';
import 'states/login.dart';

class AppModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ModuleRoute('/', module: ShopModule()),
        ChildRoute('/login', child: (_, __) => LoginPage()),
        ModuleRoute('/sales/', module: SalesModule()),
        ModuleRoute('/shop/', module: ShopModule())
      ];

  @override
  List<Bind> get binds => [Bind.lazySingleton((i) => LoginPageState())];
}
