import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock/core/services/util.dart';

class AccountModule extends Module {
  final OnGetModulesMenu onGetModulesMenu;

  AccountModule({required this.onGetModulesMenu});

  @override
  List<ModularRoute> get routes => [
        // ChildRoute(
        //   '/',
        //   guards: [AuthGuard()],
        //   child: (_, __) => ProfileIndexPage(onGetModulesMenu: onGetModulesMenu,),
        // ),
        // ChildRoute(
        //   '/profile',
        //   guards: [AuthGuard()],
        //   child: (_, __) => ProfilePage(onGetModulesMenu: onGetModulesMenu,),
        // ),
        // ChildRoute(
        //   '/users',
        //   guards: [AuthGuard()],
        //   child: (_, __) => UsersPage(onGetModulesMenu: onGetModulesMenu),
        // ),
        // ChildRoute(
        //   '/users/create',
        //   guards: [AuthGuard()],
        //   child: (_, __) => ShopUserCreatePage(onGetModulesMenu: onGetModulesMenu),
        // ),
        // // ChildRoute(
        // //   '/bill',
        // //   guards: [],
        // //   child: (_, __) => const PaymentPage(),
        // // ),
        // ChildRoute(
        //   '/login',
        //   child: (_, __) => const LoginPage(),
        // ),
        // ChildRoute(
        //   '/register',
        //   child: (_, __) => const RegisterPage(),
        // ),
        // ChildRoute(
        //   '/shop',
        //   guards: [AuthGuard()],
        //   child: (_, __) => const ChooseShopPage(),
        // )
      ];

  @override
  List<Bind> get binds => [];
}
