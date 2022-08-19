import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock_pos/stocks/pages/product_create.dart';
import 'package:smartstock_pos/stocks/pages/products.dart';

import 'pages/index.dart';
import 'states/product_loading_state.dart';
import 'states/products_list_state.dart';

class StockModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, __) => const IndexPage()),
        ChildRoute('/products', child: (_, __) => const ProductsPage()),
        ChildRoute('/products/create', child: (_, __) => const ProductCreatePage()),
      ];

  @override
  List<Bind<Object>> get binds => [
    Bind.lazySingleton((i) => ProductLoadingState()),
    Bind.lazySingleton((i) => ProductsListState()),
  ];
}
