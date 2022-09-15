import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/stocks/pages/categories.dart';
import 'package:smartstock/stocks/pages/index.dart';
import 'package:smartstock/stocks/pages/items.dart';
import 'package:smartstock/stocks/pages/product_create.dart';
import 'package:smartstock/stocks/pages/product_edit.dart';
import 'package:smartstock/stocks/pages/products.dart';
import 'package:smartstock/stocks/pages/purchase_create.dart';
import 'package:smartstock/stocks/pages/purchases.dart';
import 'package:smartstock/stocks/pages/suppliers.dart';
import 'package:smartstock/stocks/pages/transfer_receive.dart';
import 'package:smartstock/stocks/pages/transfer_send.dart';
import 'package:smartstock/stocks/pages/transfers.dart';
import 'package:smartstock/stocks/states/categories_list.dart';
import 'package:smartstock/stocks/states/categories_loading.dart';
import 'package:smartstock/stocks/states/category_create.dart';
import 'package:smartstock/stocks/states/item_create.dart';
import 'package:smartstock/stocks/states/items_list.dart';
import 'package:smartstock/stocks/states/items_loading.dart';
import 'package:smartstock/stocks/states/product_create.dart';
import 'package:smartstock/stocks/states/product_loading.dart';
import 'package:smartstock/stocks/states/products_list.dart';
import 'package:smartstock/stocks/states/supplier_create.dart';
import 'package:smartstock/stocks/states/suppliers_list.dart';
import 'package:smartstock/stocks/states/suppliers_loading.dart';

class StockModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, __) => const IndexPage()),
        ChildRoute('/products', child: (_, __) => ProductsPage(__)),
        ChildRoute('/categories', child: (_, __) => CategoriesPage(__)),
        ChildRoute('/suppliers', child: (_, __) => SuppliersPage(__)),
        ChildRoute('/purchases', child: (_, __) => PurchasesPage(__)),
        ChildRoute(
          '/purchases/create',
          child: (context, _) => purchaseCreatePage(context),
        ),
        ChildRoute('/items', child: (_, __) => ItemsPage(__)),
        ChildRoute('/products/create', child: (_, __) {
          var productState = getState<ProductCreateState>();
          productState.setIsUpdate(false);
          productState.clearFormState();
          return const ProductCreatePage();
        }),
        ChildRoute('/products/edit', child: (_, __) {
          var product = __.data;
          if (product is Map && product['id'] is String) {
            var productState = getState<ProductCreateState>();
            productState.setIsUpdate(true);
            productState.updateFormState(product as Map<String, dynamic>);
            return ProductEditPage('${product['product']}');
          }
          navigateToAndReplace('/stock/products');
          return Container();
        }),
        ChildRoute('/transfers', child: (_, __) => TransfersPage(__)),
        ChildRoute('/transfers/send', child: (_, __) => transferSendPage(_)),
        ChildRoute('/transfers/receive',
            child: (_, __) => transferReceivePage(_)),
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
