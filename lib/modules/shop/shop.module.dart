import 'package:bfastui/adapters/module.dart';
import 'package:bfastui/adapters/router.dart';
import 'package:bfastui/bfastui.dart';
import 'package:smartstock_pos/modules/shop/pages/choose-shop.page.dart';
import 'package:smartstock_pos/modules/shop/states/shops.state.dart';
import 'package:smartstock_pos/shared/guards/auth.guard.dart';

class ShopModule extends BFastUIChildModule {
  @override
  void initRoutes(String moduleName) {
    BFastUI.navigation(moduleName: moduleName).addRoute(BFastUIRouter(
      '/',
      guards: [AuthGuard()],
      page: (context, args) => ChooseShopPage(),
    ));
  }

  @override
  void initStates(String moduleName) {
    BFastUI.states(moduleName: moduleName).addState(
      (_) => ChooseShopState(),
    );
  }

  @override
  String moduleName() {
    return 'shop';
  }
}
