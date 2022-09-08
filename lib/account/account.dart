import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock/account/pages/login.dart';
import 'package:smartstock/account/states/login.dart';
import 'package:smartstock/account/states/shops.dart';
import 'package:smartstock/core/guards/auth.dart';
import 'package:smartstock/account/pages/choose_shop.dart';

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
