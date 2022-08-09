import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock_pos/modules/shared/guards/auth.guard.dart';
import 'package:smartstock_pos/modules/shop/pages/choose-shop.page.dart';
import 'package:smartstock_pos/modules/shop/states/shops.state.dart';

class ShopModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          guards: [AuthGuard()],
          child: (context, args) => ChooseShopPage(),
        )
      ];

  @override
  List<Bind> get binds => [Bind.lazySingleton((i) => ChooseShopState())];
}
