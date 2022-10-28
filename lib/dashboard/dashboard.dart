import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock/core/models/external_service.dart';
import 'package:smartstock/dashboard/pages/index.dart';

class DashboardModule extends Module {
  final home = ChildRoute(
    '/',
    child: (_, __) => const DashboardIndexPage(),
  );

  DashboardModule(List<ExternalService> services);

  @override
  List<ChildRoute> get routes => [home];

  @override
  List<Bind> get binds => [];
}
