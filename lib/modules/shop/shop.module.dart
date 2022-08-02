import 'package:bfastui/adapters/child_module.dart';
import 'package:bfastui/adapters/router.dart';
import 'package:bfastui/adapters/state.dart';
import 'package:smartstock_pos/modules/shop/pages/choose-shop.page.dart';
import 'package:smartstock_pos/modules/shop/states/shops.state.dart';
import 'package:smartstock_pos/shared/guards/auth.guard.dart';

class ShopModule extends ChildModuleAdapter {
  @override
  List<RouterAdapter> initRoutes(String moduleName) => [
    RouterAdapter(
      '/',
      guards: [AuthGuard()],
      page: (context, args) => ChooseShopPage(),
    )
  ];

  @override
  List<StateAdapter> initStates(String moduleName) => [
    ChooseShopState()
  ];

  @override
  String moduleName() {
    return 'shop';
  }
}
