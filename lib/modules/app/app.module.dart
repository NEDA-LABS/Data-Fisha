import 'package:bfastui/adapters/main-module.adapter.dart';
import 'package:bfastui/adapters/router.adapter.dart';
import 'package:bfastui/bfastui.dart';
import 'package:smartstock_pos/modules/sales/sales.module.dart';
import 'package:smartstock_pos/modules/shop/shop.module.dart';

import 'pages/login.page.dart';
import 'states/login.state.dart';

class AppModule extends MainModuleAdapter {
  @override
  void initRoutes(String moduleName) {
    BFastUI.navigation(moduleName: moduleName)
        .addRoute(RouterAdapter(
          '/login',
          page: (context, args) => LoginPage(),
        ))
        .addRoute(RouterAdapter(
          '/sales',
          module: BFastUI.childModule(
            SalesModule(),
          ),
        ))
        .addRoute(RouterAdapter(
          '/shop',
          module: BFastUI.childModule(
            ShopModule(),
          ),
        ));
  }

  @override
  void initStates(String moduleName) {
    BFastUI.states(moduleName: moduleName).addState(
      (_) => LoginPageState(),
    );
  }
}
