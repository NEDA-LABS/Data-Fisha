import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock/core/guards/auth.dart';
import 'package:smartstock/dashboard/pages/index.dart';
import 'package:smartstock/sales/guards/active_shop.dart';

class ReportModule extends Module {
  final home = ChildRoute(
    '/',
    child: (_, __) => const DashboardIndexPage(),
  );

  @override
  List<ChildRoute> get routes => [home];

  @override
  List<Bind> get binds => [];
}
