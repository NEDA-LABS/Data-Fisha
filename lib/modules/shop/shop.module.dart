import 'package:bfastui/adapters/module.dart';
import 'package:bfastui/adapters/router.dart';
import 'package:bfastui/bfastui.dart';
import 'package:smartstock/modules/shop/pages/choose-shop.page.dart';

class ShopModule extends BFastUIChildModule {
  @override
  void initRoutes(String moduleName) {
    BFastUI.navigation(moduleName: moduleName).addRoute(BFastUIRouter(
      '/',
      page: (context, args) => ChooseShopPage(),
    ));
  }

  @override
  void initStates(String moduleName) {
    // TODO: implement initStates
  }

  @override
  String moduleName() {
    return 'shop';
  }
}
