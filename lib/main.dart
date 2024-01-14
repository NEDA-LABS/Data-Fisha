import 'package:flutter/material.dart';
import 'package:smartstock/account/pages/index.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/dashboard/pages/index.dart';
import 'package:smartstock/expense/pages/index.dart';
import 'package:smartstock/initializer.dart';
import 'package:smartstock/report/pages/index.dart';
import 'package:smartstock/sales/pages/customers.dart';
import 'package:smartstock/sales/pages/index.dart';
import 'package:smartstock/sales/pages/sales_cash.dart';
import 'package:smartstock/sales/pages/sales_cash_retail.dart';
import 'package:smartstock/sales/pages/sales_cash_whole.dart';
import 'package:smartstock/sales/pages/sales_invoice.dart';
import 'package:smartstock/sales/pages/sales_invoice_retail.dart';
import 'package:smartstock/sales/pages/sales_orders.dart';
import 'package:smartstock/sales/pages/sold_items.dart';
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
      link: dashboardIndex.pageName,
      page: dashboardIndex,
      roles: ['admin'],
    ),
    _getSalesMenu(
        context: context, onBackPage: onBackPage, onChangePage: onChangePage),
    _getInventoryMenu(
        context: context, onBackPage: onBackPage, onChangePage: onChangePage),
    ModuleMenu(
      name: 'Expenses',
      icon: Icon(Icons.receipt_long_rounded,
          color: Theme.of(context).colorScheme.primary),
      link: expenseIndex.pageName,
      page: expenseIndex,
      // onClick: () => null,
      roles: ['*'],
    ),
    ModuleMenu(
      name: 'Reports',
      icon: Icon(Icons.data_saver_off,
          color: Theme.of(context).colorScheme.primary),
      link: reportIndex.pageName,
      page: reportIndex,
      // onClick: () => null,
      roles: ['admin'],
    ),
    ModuleMenu(
      name: 'Account',
      icon: Icon(Icons.supervised_user_circle,
          color: Theme.of(context).colorScheme.primary),
      link: accountIndex.pageName,
      page: accountIndex,
      roles: ['*'],
    ),
  ];
}

_getInventoryMenu(
    {required BuildContext context,
    required OnBackPage onBackPage,
    required OnChangePage onChangePage}) {
  var productsPage =
      ProductsPage(onBackPage: onBackPage, onChangePage: onChangePage);
  var categoriesPage =
      CategoriesPage(onBackPage: onBackPage, onChangePage: onChangePage);
  var purchasePage =
      PurchasesPage(onBackPage: onBackPage, onChangePage: onChangePage);
  var transfersPage =
      TransfersPage(onBackPage: onBackPage, onChangePage: onChangePage);
  var productsSummaryPage =
      StocksIndexPage(onBackPage: onBackPage, onChangePage: onChangePage);
  return ModuleMenu(
      name: 'Inventory',
      icon: Icon(Icons.inventory, color: Theme.of(context).colorScheme.primary),
      link: productsPage.pageName,
      page: productsPage,
      roles: [
        'admin',
        'manager'
      ],
      children: [
        ModuleMenu(
          name: 'Products',
          link: productsPage.pageName,
          roles: ['admin', 'manager'],
          page: productsPage,
          icon: const Icon(Icons.sell),
          // onClick: () => null,
        ),
        ModuleMenu(
          name: 'Categories',
          link: categoriesPage.pageName,
          roles: ['admin', 'manager'],
          icon: const Icon(Icons.category),
          page: categoriesPage,
        ),
        // ModuleMenu(
        //     name: 'Suppliers',
        //     link: '/stock/suppliers',
        //     roles: ['admin', 'manager'],
        //     icon: const Icon(Icons.support_agent_sharp),
        //     page: SuppliersPage(onBackPage: onBackPage)),
        ModuleMenu(
          name: 'Purchases',
          link: purchasePage.pageName,
          roles: ['admin', 'manager'],
          icon: const Icon(Icons.receipt),
          page: purchasePage,
        ),
        ModuleMenu(
          name: 'Transfer',
          link: transfersPage.pageName,
          roles: ['admin', 'manager'],
          icon: const Icon(Icons.change_circle),
          page: transfersPage,
        ),
        ModuleMenu(
          name: 'Summary',
          link: productsSummaryPage.pageName,
          roles: ['admin', 'manager'],
          icon: const Icon(Icons.bar_chart),
          page: productsSummaryPage,
        ),
      ]);
}

ModuleMenu _getSalesMenu(
    {required OnBackPage onBackPage,
    required OnChangePage onChangePage,
    required BuildContext context}) {
  var salesCashRetailPage = SalesCashRetail(onBackPage: onBackPage);
  var salesCashWholePage = SalesCashWhole(onBackPage: onBackPage);
  var invoiceCreatePage = InvoiceSalePage(onBackPage: onBackPage);
  var invoicesPage = InvoicesPage(
    onBackPage: onBackPage,
    onChangePage: onChangePage,
  );
  var receiptsPage = SalesCashPage(
    onBackPage: onBackPage,
    onChangePage: onChangePage,
  );
  var soldItemsPage = SoldItemsPage(
    onBackPage: onBackPage,
    onChangePage: onChangePage,
  );
  var ordersPage =
      OrdersPage(onBackPage: onBackPage, onChangePage: onChangePage);
  var customersPage = CustomersPage(onBackPage: onBackPage);
  var salesSummaryPage = SalesPage(
    onBackPage: onBackPage,
    onChangePage: onChangePage,
  );
  var salesIndex = SalesCashRetail(onBackPage: onBackPage);
  return ModuleMenu(
    name: 'Point Of Sale',
    icon:
        Icon(Icons.point_of_sale, color: Theme.of(context).colorScheme.primary),
    link: salesCashRetailPage.pageName,
    page: salesCashRetailPage,
    roles: ['*'],
    children: [
      ModuleMenu(
        name: 'Create retail sale',
        link: salesCashRetailPage.pageName,
        icon: const Icon(Icons.storefront_sharp),
        roles: ['*'],
        page: salesCashRetailPage,
      ),
      ModuleMenu(
        name: 'Create wholesale',
        link: '/sales/cash',
        icon: const Icon(Icons.business),
        roles: ['*'],
        page: salesCashWholePage,
      ),
      ModuleMenu(
        name: 'Create invoice',
        link: invoiceCreatePage.pageName,
        icon: const Icon(Icons.add_card_sharp),
        roles: ['*'],
        page: invoiceCreatePage,
      ),
      ModuleMenu(
        name: 'Sold items',
        link: soldItemsPage.pageName,
        icon: const Icon(Icons.paste),
        roles: ['*'],
        page: soldItemsPage,
      ),
      ModuleMenu(
        name: 'Invoices',
        link: invoicesPage.pageName,
        icon: const Icon(Icons.receipt_long),
        roles: ['*'],
        page: invoicesPage,
      ),
      ModuleMenu(
        name: 'Receipts',
        link: receiptsPage.pageName,
        icon: const Icon(Icons.receipt),
        roles: ['*'],
        page: receiptsPage,
      ),
      ModuleMenu(
        name: 'Customers',
        link: customersPage.pageName,
        icon: const Icon(Icons.supervised_user_circle_outlined),
        roles: ['*'],
        page: customersPage,
      ),
      ModuleMenu(
        name: 'Orders',
        link: ordersPage.pageName,
        icon: const Icon(Icons.receipt_long),
        roles: ['*'],
        page: ordersPage,
      ),
      ModuleMenu(
        name: 'Summary',
        link: salesSummaryPage.pageName,
        icon: const Icon(Icons.bar_chart),
        roles: ['admin'],
        page: salesSummaryPage,
      ),
    ],
  );
}

List<ModuleMenu> _getEmptyMenu({
  required context,
  required onBackPage,
  required onChangePage,
}) {
  return [];
}

void main() {
  initializeSmartStock(onGetAppMenu: _onGetModules);

  // initializeSmartStock(
  //     onGetModulesMenu: _getEmptyMenu,
  //     onGetInitialModule: ({required onBackPage, required onChangePage}) =>
  //         ProductsPage(onBackPage: onBackPage, onChangePage: onChangePage));
}
