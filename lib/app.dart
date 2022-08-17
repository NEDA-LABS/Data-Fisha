import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock_pos/account/account.dart';

import '../sales/sales.dart';

class AppModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ModuleRoute('/', module: AccountModule()),
        ModuleRoute('/sales/', module: SalesModule()),
      ];

  @override
  List<Bind> get binds => [];
}
