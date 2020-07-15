import 'package:bfastui/adapters/module.dart';
import 'package:bfastui/adapters/router.dart';
import 'package:bfastui/bfastui.dart';
import 'package:bfastui/controllers/state.dart';
import 'package:smartstock/modules/dashboard/pages/dashboard.page.dart';
import 'package:smartstock/modules/dashboard/states/shop-details.state.dart';

class DashboardModule extends BFastUIChildModule{
  @override
  void initRoutes(String moduleName) {
    BFastUI.navigation(moduleName: moduleName).addRoute(
      BFastUIRouter(
        '/',
        page: (context, args) => DashBoardPage(),
      ),
    );
  }

  @override
  void initStates(String moduleName) {
    BFastUI.states(moduleName: moduleName).addState(
      BFastUIStateBinder((_) => ShopDetailsState()),
    );
  }

  @override
  String moduleName() {
    return 'dashboard';
  }

}