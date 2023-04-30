import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock/core/guards/auth.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/sales/guards/active_shop.dart';
import 'package:smartstock/sales/pages/customers.dart';
import 'package:smartstock/sales/pages/index.dart';
import 'package:smartstock/sales/pages/sales_cach_whole.dart';
import 'package:smartstock/sales/pages/sales_cash.dart';
import 'package:smartstock/sales/pages/sales_cash_retail.dart';
import 'package:smartstock/sales/pages/sales_invoice.dart';
import 'package:smartstock/sales/pages/sales_invoice_retail.dart';

class SalesModule extends Module {
  final OnGetModulesMenu onGetModulesMenu;

  SalesModule({required this.onGetModulesMenu});

  @override
  List<ChildRoute> get routes => [
        ChildRoute(
          '/',
          guards: [AuthGuard(), ActiveShopGuard()],
          child: (_, __) => SalesPage(
            onGetModulesMenu: onGetModulesMenu,
          ),
        ),
        ChildRoute(
          '/cash',
          guards: [AuthGuard(), ActiveShopGuard()],
          child: (context, args) =>
              SalesCashPage(onGetModulesMenu: onGetModulesMenu),
        ),
        ChildRoute(
          '/cash/whole',
          guards: [AuthGuard(), ActiveShopGuard()],
          child: (context, args) =>
              SalesCashWhole(onGetModulesMenu: onGetModulesMenu),
        ),
        ChildRoute(
          '/cash/retail',
          guards: [AuthGuard(), ActiveShopGuard()],
          child: (context, args) =>
              SalesCashRetail(onGetModulesMenu: onGetModulesMenu),
        ),
        ChildRoute(
          '/customers',
          guards: [AuthGuard(), ActiveShopGuard()],
          child: (context, args) =>
              CustomersPage(onGetModulesMenu: onGetModulesMenu),
        ),
        ChildRoute(
          '/invoice',
          guards: [AuthGuard(), ActiveShopGuard()],
          child: (context, args) =>
              InvoicesPage(onGetModulesMenu: onGetModulesMenu),
        ),
        ChildRoute(
          '/invoice/create',
          guards: [AuthGuard(), ActiveShopGuard()],
          child: (context, args) =>
              invoiceSalePage(context, onGetModulesMenu: onGetModulesMenu),
        ),
      ];

  @override
  List<Bind> get binds => [];
}
