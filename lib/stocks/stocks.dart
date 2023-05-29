import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock/core/guards/auth.dart';
import 'package:smartstock/core/guards/manager.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/sales/guards/active_shop.dart';
import 'package:smartstock/stocks/models/InventoryType.dart';
import 'package:smartstock/stocks/pages/categories.dart';
import 'package:smartstock/stocks/pages/index.dart';
import 'package:smartstock/stocks/pages/product_create.dart';
import 'package:smartstock/stocks/pages/product_edit.dart';
import 'package:smartstock/stocks/pages/products.dart';
import 'package:smartstock/stocks/pages/purchase_create.dart';
import 'package:smartstock/stocks/pages/purchases.dart';
import 'package:smartstock/stocks/pages/suppliers.dart';
import 'package:smartstock/stocks/pages/transfer_receive.dart';
import 'package:smartstock/stocks/pages/transfer_send.dart';
import 'package:smartstock/stocks/pages/transfers.dart';

class StockModule extends Module {
  final OnGetModulesMenu onGetModulesMenu;

  StockModule({required this.onGetModulesMenu});

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/',
            guards: [AuthGuard(), ActiveShopGuard(), ManagerGuard()],
            child: (_, __) => StocksIndexPage()),
        ChildRoute('/products',
            guards: [AuthGuard(), ActiveShopGuard(), ManagerGuard()],
            child: (_, __) => ProductsPage()),
        ChildRoute('/categories',
            guards: [AuthGuard(), ActiveShopGuard(), ManagerGuard()],
            child: (_, __) => CategoriesPage()),
        ChildRoute('/suppliers',
            guards: [AuthGuard(), ActiveShopGuard(), ManagerGuard()],
            child: (_, __) => SuppliersPage()),
        ChildRoute('/purchases',
            guards: [AuthGuard(), ActiveShopGuard(), ManagerGuard()],
            child: (_, __) => PurchasesPage()),
        ChildRoute(
          '/purchases/create',
          guards: [AuthGuard(), ActiveShopGuard(), ManagerGuard()],
          child: (_, __) => PurchaseCreatePage(),
        ),
        ChildRoute('/products/create',
            guards: [AuthGuard(), ActiveShopGuard(), ManagerGuard()],
            child: (_, __) {
          return ProductCreatePage(
            inventoryType: InventoryType.product,
          );
        }),
        ChildRoute('/products/edit',
            guards: [AuthGuard(), ActiveShopGuard(), ManagerGuard()],
            child: (_, __) {
          var product = __.data;
          if (product is Map && product['id'] != null) {
            return ProductEditPage(product);
          }
          navigateToAndReplace('/stock/products');
          return Container();
        }),
        ChildRoute('/transfers',
            guards: [AuthGuard(), ActiveShopGuard(), ManagerGuard()],
            child: (_, __) => TransfersPage()),
        ChildRoute('/transfers/send',
            guards: [AuthGuard(), ActiveShopGuard(), ManagerGuard()],
            child: (_, __) =>
                transferSendPage(_, onGetModulesMenu: onGetModulesMenu)),
        ChildRoute('/transfers/receive',
            guards: [AuthGuard(), ActiveShopGuard(), ManagerGuard()],
            child: (_, __) =>
                transferReceivePage(_, onGetModulesMenu: onGetModulesMenu)),
      ];

  @override
  List<Bind<Object>> get binds => [];
}
