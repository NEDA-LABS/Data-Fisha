import 'package:bfastui/adapters/module.dart';
import 'package:bfastui/adapters/router.dart';
import 'package:bfastui/bfastui.dart';
import 'package:smartstock/modules/sales/pages/sales.page.dart';

class SalesModule extends BFastUIChildModule {
  @override
  void initRoutes(String moduleName) {
    BFastUI.navigation(moduleName: moduleName).addRoute(
      BFastUIRouter(
        '/',
        page: (context, args) => SalesPage(),
      ),
    );
  }

  @override
  void initStates(String moduleName) {}

  @override
  String moduleName() {
    return 'sales';
  }
}
