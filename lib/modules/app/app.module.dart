import 'package:bfastui/adapters/main_module.dart';
import 'package:bfastui/adapters/router.dart';
import 'package:bfastui/adapters/state.dart';
import 'package:smartstock_pos/modules/sales/sales.module.dart';
import 'package:smartstock_pos/modules/shop/shop.module.dart';

import 'pages/login.page.dart';
import 'states/login.state.dart';

class AppModule extends MainModuleAdapter {
  @override
  List<RouterAdapter> initRoutes(String moduleName) => [
        RouterAdapter(
          '/login',
          page: (context, args) => LoginPage(),
        ),
        RouterAdapter(
          '/sales',
          module: SalesModule(),
        ),
        RouterAdapter(
          '/shop',
          module: ShopModule(),
        )
      ];

  @override
  List<StateAdapter> initStates(_) => [LoginPageState()];
}
