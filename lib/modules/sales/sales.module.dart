import 'package:bfastui/adapters/module.dart';
import 'package:bfastui/adapters/router.dart';
import 'package:bfastui/bfastui.dart';
import 'package:bfastui/controllers/state.dart';
import 'package:smartstock/modules/account/states/login.state.dart';
import 'package:smartstock/modules/sales/guard/AuthGuard.dart';
import 'package:smartstock/modules/sales/pages/retail.page.dart';
import 'package:smartstock/modules/sales/pages/sales.page.dart';
import 'package:smartstock/modules/sales/pages/wholesale.page.dart';

class SalesModule extends BFastUIChildModule {
  @override
  void initRoutes(String moduleName) {
    BFastUI.navigation(moduleName: moduleName)
        .addRoute(
          BFastUIRouter(
            '/',
            guards: [AuthGuard()],
            page: (context, args) => SalesPage(),
          ),
        )
        .addRoute(BFastUIRouter(
          '/whole',
          guards: [AuthGuard()],
          page: (context, args) => WholesalePage(),
        ))
        .addRoute(BFastUIRouter(
          '/retail',
          guards: [AuthGuard()],
          page: (context, args) => RetailPage(),
        ));
  }

  @override
  void initStates(String moduleName) {
    BFastUI.states(moduleName: moduleName)
        .addState(BFastUIStateBinder((_) => LoginPageState()));
  }

  @override
  String moduleName() {
    return 'sales';
  }
}
