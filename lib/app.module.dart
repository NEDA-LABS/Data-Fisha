import 'package:bfastui/adapters/module.dart';
import 'package:bfastui/adapters/router.dart';
import 'package:bfastui/bfastui.dart';
import 'package:smartstock/modules/account/account.module.dart';
import 'package:smartstock/modules/sales/sales.module.dart';
import 'package:smartstock/modules/shop/shop.module.dart';

class SmartStockPos extends BFastUIMainModule {
  @override
  void initRoutes(String moduleName) {
    BFastUI.navigation(moduleName: moduleName)
        .addRoute(BFastUIRouter(
          '/account',
          module: BFastUI.childModule(AccountModule()),
        ))
        .addRoute(BFastUIRouter(
          '/sales',
          module: BFastUI.childModule(SalesModule()),
        ))
        .addRoute(BFastUIRouter(
          '/shop',
          module: BFastUI.childModule(ShopModule()),
        ));
  }

  @override
  void initStates(String moduleName) {}
}
