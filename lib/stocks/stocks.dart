import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock_pos/stocks/pages/products.dart';

import 'pages/index.dart';

class StockModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, __) => const IndexPage()),
        ChildRoute('/products', child: (_, __) => const ProductsPage()),
      ];

  @override
  List<Bind<Object>> get binds => [];
}
