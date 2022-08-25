import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock_pos/stocks/pages/product_create.dart';
import 'package:smartstock_pos/stocks/pages/products.dart';
import 'package:smartstock_pos/stocks/states/category_create.dart';
import 'package:smartstock_pos/stocks/states/product_create.dart';
import 'package:smartstock_pos/stocks/states/supplier_create.dart';

import 'pages/index.dart';
import 'states/product_loading.dart';
import 'states/products_list.dart';

class StockModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, __) => const IndexPage()),
        ChildRoute('/products', child: (_, __) => ProductsPage(__)),
        ChildRoute('/products/create', child: (_, __) => const ProductCreatePage()),
      ];

  @override
  List<Bind<Object>> get binds => [
    Bind.lazySingleton((i) => ProductLoadingState()),
    Bind.lazySingleton((i) => ProductsListState()),
    Bind.lazySingleton((i) => ProductFormState()),
    Bind.lazySingleton((i) => CategoryCreateState()),
    Bind.lazySingleton((i) => SupplierCreateState()),
  ];
}
