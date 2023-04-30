import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock/core/guards/auth.dart';
import 'package:smartstock/sales/guards/active_shop.dart';

class FeatureModule extends Module {
  final Widget child;

  FeatureModule({required this.child}) : super();

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          guards: [AuthGuard(), ActiveShopGuard()],
          child: (context, args) => child,
        )
      ];
}
