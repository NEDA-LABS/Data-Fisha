import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock/core/guards/auth.dart';
import 'package:smartstock/core/guards/owner.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/dashboard/pages/index.dart';
import 'package:smartstock/sales/guards/active_shop.dart';

class DashboardModule extends Module {

  DashboardModule();

  @override
  List<ChildRoute> get routes => [
        ChildRoute(
          '/',
          guards: [AuthGuard(), ActiveShopGuard(), OwnerGuard()],
          child: (_, __) =>
              DashboardIndexPage(),
        )
      ];

  @override
  List<Bind> get binds => [];
}
