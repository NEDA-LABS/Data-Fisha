import 'package:flutter_modular/flutter_modular.dart';

import 'pages/index.dart';
import 'states/refresh_state.dart';

class StockModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, __) => const IndexPage()),
      ];

  @override
  List<Bind<Object>> get binds => [];
}
