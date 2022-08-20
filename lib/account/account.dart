import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock_pos/core/guards/auth.dart';
import 'package:smartstock_pos/account/pages/choose_shop.dart';

import 'pages/login.dart';
import 'states/login.dart';
import 'states/shops.dart';

class AccountModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute('/',
            guards: [AuthGuard()], child: (_, __) => const ChooseShopPage()),
        ChildRoute('/login', child: (_, __) => const LoginPage()),
        // ModuleRoute('/sales/', module: SalesModule()),
        ChildRoute('/shop',
            guards: [AuthGuard()], child: (_, __) => const ChooseShopPage())
      ];

  @override
  List<Bind> get binds => [
        Bind.lazySingleton((i) => LoginPageState()),
        Bind.lazySingleton((i) => ChooseShopState())
      ];
}
