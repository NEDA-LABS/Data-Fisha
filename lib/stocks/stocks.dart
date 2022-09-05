import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock/stocks/pages/items.dart';
import 'package:smartstock/stocks/pages/suppliers.dart';
import 'package:smartstock/stocks/states/categories_list.dart';
import 'package:smartstock/stocks/states/categories_loading.dart';
import 'package:smartstock/stocks/states/item_create.dart';
import 'package:smartstock/stocks/states/items_list.dart';
import 'package:smartstock/stocks/states/items_loading.dart';
import 'package:smartstock/stocks/states/suppliers_list.dart';
import 'package:smartstock/stocks/states/suppliers_loading.dart';

import 'pages/categories.dart';
import 'pages/index.dart';
import 'pages/product_create.dart';
import 'pages/products.dart';
import 'states/category_create.dart';
import 'states/product_create.dart';
import 'states/product_loading.dart';
import 'states/products_list.dart';
import 'states/supplier_create.dart';

class StockModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, __) => const IndexPage()),
        ChildRoute('/products', child: (_, __) => ProductsPage(__)),
        ChildRoute('/categories', child: (_, __) => CategoriesPage(__)),
        ChildRoute('/suppliers', child: (_, __) => SuppliersPage(__)),
        ChildRoute('/items', child: (_, __) => ItemsPage(__)),
        ChildRoute('/products/create',
            child: (_, __) => const ProductCreatePage()),
      ];

  @override
  List<Bind<Object>> get binds => [
        Bind.lazySingleton((i) => ProductLoadingState()),
        Bind.lazySingleton((i) => CategoriesLoadingState()),
        Bind.lazySingleton((i) => ProductsListState()),
        Bind.lazySingleton((i) => ProductCreateState()),
        Bind.lazySingleton((i) => CategoryCreateState()),
        Bind.lazySingleton((i) => SupplierCreateState()),
        Bind.lazySingleton((i) => CategoriesListState()),
        Bind.lazySingleton((i) => SuppliersListState()),
        Bind.lazySingleton((i) => SuppliersLoadingState()),
        Bind.lazySingleton((i) => ItemCreateState()),
        Bind.lazySingleton((i) => ItemsListState()),
        Bind.lazySingleton((i) => ItemsLoadingState()),
      ];
}
