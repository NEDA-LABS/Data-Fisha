import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock/account/pages/choose_shop.dart';
import 'package:smartstock/account/pages/login.dart';
import 'package:smartstock/account/pages/profile.dart';
import 'package:smartstock/account/pages/register.dart';
import 'package:smartstock/account/pages/user_create.dart';
import 'package:smartstock/account/pages/users.dart';
import 'package:smartstock/account/states/shops.dart';
import 'package:smartstock/core/guards/auth.dart';

class AccountModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          guards: [AuthGuard()],
          child: (_, __) => const ProfilePage(),
        ),
        ChildRoute(
          '/profile',
          guards: [AuthGuard()],
          child: (_, __) => const ProfilePage(),
        ),
        ChildRoute(
          '/users',
          guards: [AuthGuard()],
          child: (_, __) => const UsersPage(),
        ),
        ChildRoute(
          '/users/create',
          guards: [AuthGuard()],
          child: (_, __) => const ShopUserCreatePage(),
        ),
        ChildRoute(
          '/login',
          child: (_, __) => const LoginPage(),
        ),
        ChildRoute(
          '/register',
          child: (_, __) => const RegisterPage(),
        ),
        ChildRoute(
          '/shop',
          guards: [AuthGuard()],
          child: (_, __) => const ChooseShopPage(),
        )
      ];

  @override
  List<Bind> get binds => [Bind.lazySingleton((i) => ChooseShopState())];
}
