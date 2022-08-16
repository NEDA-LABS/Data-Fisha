import 'package:flutter_modular/flutter_modular.dart';
import 'guards/auth.dart';
import 'pages/choose-shop.page.dart';
import 'states/shops.state.dart';

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
