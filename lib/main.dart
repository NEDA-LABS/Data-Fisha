import 'package:flutter/material.dart';
import 'package:smartstock/account/pages/index.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/dashboard/pages/index.dart';
import 'package:smartstock/expense/pages/index.dart';
import 'package:smartstock/initializer.dart';
import 'package:smartstock/report/pages/index.dart';
import 'package:smartstock/sales/pages/index.dart';
import 'package:smartstock/stocks/models/InventoryType.dart';
import 'package:smartstock/stocks/pages/categories.dart';
import 'package:smartstock/stocks/pages/index.dart';
import 'package:smartstock/stocks/pages/product_create.dart';
import 'package:smartstock/stocks/pages/ProductsPage.dart';
import 'package:smartstock/stocks/pages/purchases.dart';
import 'package:smartstock/stocks/pages/suppliers.dart';
import 'package:smartstock/stocks/pages/transfers.dart';

List<ModuleMenu> _onGetModules({
  required BuildContext context,
  required OnChangePage onChangePage,
  required OnBackPage onBackPage,
}) {
  var dashboardIndex = const DashboardIndexPage();
  var reportIndex =
      ReportIndexPage(onChangePage: onChangePage, onBackPage: onBackPage);
  var salesIndex =
      SalesPage(onChangePage: onChangePage, onBackPage: onBackPage);
  var expenseIndex =
      ExpenseIndexPage(onChangePage: onChangePage, onBackPage: onBackPage);
  var accountIndex =
      ProfileIndexPage(onChangePage: onChangePage, onBackPage: onBackPage);
  return [
    ModuleMenu(
      name: 'Dashboard',
      icon: Icon(
        Icons.dashboard,
        color: Theme.of(context).colorScheme.primary,
      ),
      link: '/dashboard/',
      page: dashboardIndex,
      // onClick: () => null,
      roles: ['admin'],
    ),
    ModuleMenu(
      name: 'Point Of Sale',
      icon: Icon(Icons.point_of_sale,
          color: Theme.of(context).colorScheme.primary),
      link: '/sales/',
      page: salesIndex,
      // onClick: () => null,
      roles: ['*'],
    ),
    ModuleMenu(
        name: 'Inventory',
        icon:
            Icon(Icons.inventory, color: Theme.of(context).colorScheme.primary),
        link: '/stock/',
        page:
            StocksIndexPage(onChangePage: onChangePage, onBackPage: onBackPage),
        // onClick: () => null,
        roles: [
          'admin',
          'manager'
        ],
        children: [
          ModuleMenu(
            name: 'Products',
            link: '/stock/products',
            roles: ['admin', 'manager'],
            page: ProductsPage(
                onBackPage: onBackPage, onChangePage: onChangePage),
            icon: const Icon(Icons.sell),
            // onClick: () => null,
          ),
          ModuleMenu(
              name: 'Categories',
              link: '/stock/categories',
              roles: ['admin', 'manager'],
              icon: const Icon(Icons.category),
              page: CategoriesPage(
                  onBackPage: onBackPage, onChangePage: onChangePage)),
          // ModuleMenu(
          //     name: 'Suppliers',
          //     link: '/stock/suppliers',
          //     roles: ['admin', 'manager'],
          //     icon: const Icon(Icons.support_agent_sharp),
          //     page: SuppliersPage(onBackPage: onBackPage)),
          ModuleMenu(
              name: 'Purchases',
              link: '/stock/purchases',
              roles: ['admin', 'manager'],
              icon: const Icon(Icons.receipt),
              page: PurchasesPage(
                  onBackPage: onBackPage, onChangePage: onChangePage)),
          ModuleMenu(
              name: 'Transfer',
              link: '/stock/transfers',
              roles: ['admin', 'manager'],
              icon: const Icon(Icons.change_circle),
              page: TransfersPage(
                  onBackPage: onBackPage, onChangePage: onChangePage)),
          ModuleMenu(
              name: 'Summary',
              link: '/stock/reports',
              roles: ['admin', 'manager'],
              icon: const Icon(Icons.bar_chart),
              page: StocksIndexPage(
                  onBackPage: onBackPage, onChangePage: onChangePage)),
        ]),
    ModuleMenu(
      name: 'Expenses',
      icon: Icon(Icons.receipt_long_rounded,
          color: Theme.of(context).colorScheme.primary),
      link: '/expense/',
      page: expenseIndex,
      // onClick: () => null,
      roles: ['*'],
    ),
    ModuleMenu(
      name: 'Reports',
      icon: Icon(Icons.data_saver_off,
          color: Theme.of(context).colorScheme.primary),
      link: '/report/',
      page: reportIndex,
      // onClick: () => null,
      roles: ['admin'],
    ),
    ModuleMenu(
      name: 'Account',
      icon: Icon(Icons.supervised_user_circle,
          color: Theme.of(context).colorScheme.primary),
      link: '/account/',
      page: accountIndex,
      // onClick: () => null,
      roles: ['*'],
    ),
  ];
}

List<ModuleMenu> _getEmptyMenu({
  required context,
  required onBackPage,
  required onChangePage,
}) =>
    [];

void main() {
  initializeSmartStock(onGetAppMenu: _onGetModules);

  // initializeSmartStock(
  //     onGetModulesMenu: _getEmptyMenu,
  //     onGetInitialModule: ({required onBackPage, required onChangePage}) =>
  //         ProductsPage(onBackPage: onBackPage, onChangePage: onChangePage));
}
