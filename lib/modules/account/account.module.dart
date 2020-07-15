import 'package:bfastui/adapters/module.dart';
import 'package:bfastui/adapters/router.dart';
import 'package:bfastui/bfastui.dart';
import 'package:bfastui/controllers/state.dart';

import 'pages/login.page.dart';
import 'states/login.state.dart';

class AccountModule extends BFastUIChildModule {
  @override
  initStates(String moduleName) {
    BFastUI.states(moduleName: moduleName).addState(
      BFastUIStateBinder((_) => LoginPageState()),
    );
  }

  @override
  initRoutes(String moduleName) {
    BFastUI.navigation(moduleName: moduleName).addRoute(BFastUIRouter(
      '/login',
      page: (context, args) => LoginPage(),
    ));
  }

  @override
  String moduleName() {
    return 'account';
  }
}
