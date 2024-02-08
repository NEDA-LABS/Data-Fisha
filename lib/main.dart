import 'package:flutter/material.dart';
import 'package:smartstock/account/pages/profile.dart';
import 'package:smartstock/account/pages/users.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/dashboard/pages/index.dart';
import 'package:smartstock/expense/pages/ExpensesPage.dart';
import 'package:smartstock/initializer.dart';
import 'package:smartstock/report/pages/sales_cash_overview.dart';
import 'package:smartstock/report/pages/sales_cash_tracking.dart';
import 'package:smartstock/report/pages/sales_category_performance.dart';
import 'package:smartstock/report/pages/sales_invoice_overview.dart';
import 'package:smartstock/report/pages/sales_product_performance.dart';
import 'package:smartstock/report/pages/sales_seller_performance.dart';
import 'package:smartstock/sales/pages/customers.dart';
import 'package:smartstock/sales/pages/sales_cash.dart';
import 'package:smartstock/sales/pages/sales_cash_retail.dart';
import 'package:smartstock/sales/pages/sales_cash_whole.dart';
import 'package:smartstock/sales/pages/InvoicesPage.dart';
import 'package:smartstock/sales/pages/sales_invoice_retail.dart';
import 'package:smartstock/sales/pages/sales_orders.dart';
import 'package:smartstock/sales/pages/sold_items.dart';
import 'package:smartstock/stocks/pages/ProductsPage.dart';
import 'package:smartstock/stocks/pages/categories.dart';
import 'package:smartstock/stocks/pages/index.dart';
import 'package:smartstock/stocks/pages/PurchasesPage.dart';
import 'package:smartstock/stocks/pages/PurchaseCreatePage.dart';
import 'package:smartstock/stocks/pages/transfers.dart';

List<ModuleMenu> _onGetModules({
  required BuildContext context,
  required OnChangePage onChangePage,
  required OnBackPage onBackPage,
}) {
  return [
    _getDashboardMenu(
        context: context, onBackPage: onBackPage, onChangePage: onChangePage),
    _getSalesMenu(
        context: context, onBackPage: onBackPage, onChangePage: onChangePage),
    _getInventoryMenu(
        context: context, onBackPage: onBackPage, onChangePage: onChangePage),
    _getExpensesMenu(
        context: context, onBackPage: onBackPage, onChangePage: onChangePage),
    _getReportMenu(
        context: context, onBackPage: onBackPage, onChangePage: onChangePage),
    _getAccountMenu(
        context: context, onBackPage: onBackPage, onChangePage: onChangePage),
  ];
}

ModuleMenu _getAccountMenu(
    {required BuildContext context,
    required OnBackPage onBackPage,
    required OnChangePage onChangePage}) {
  var profilePage = ProfilePage(onBackPage: onBackPage);
  var usersPage = UsersPage(onBackPage: onBackPage, onChangePage: onChangePage);
  return ModuleMenu(
    name: 'Account',
    icon: Icon(Icons.supervised_user_circle_outlined,
        color: Theme.of(context).colorScheme.primary),
    link: profilePage.pageName,
    page: profilePage,
    roles: ['*'],
    children: [
      ModuleMenu(
        name: 'My profile',
        link: profilePage.pageName,
        icon: Icon(Icons.person_outline,
            color: Theme.of(context).colorScheme.primary),
        roles: ["*"],
        page: profilePage,
      ),
      ModuleMenu(
        name: 'Users',
        link: usersPage.pageName,
        icon: Icon(Icons.groups_outlined,
            color: Theme.of(context).colorScheme.primary),
        roles: ["admin", 'manager'],
        page: usersPage,
      )
    ],
  );
}

ModuleMenu _getReportMenu(
    {required BuildContext context,
    required OnBackPage onBackPage,
    required OnChangePage onChangePage}) {
  var cashOverviewPage = OverviewCashSales(onBackPage: onBackPage);
  var invoiceOverviewPage = OverviewInvoiceSales(onBackPage: onBackPage);
  var salesCashTrackingPage = SalesCashTrackingPage(onBackPage: onBackPage);
  var productPerformancePage = ProductPerformance(onBackPage: onBackPage);
  var sellerPerformancePage = SellerPerformance(onBackPage: onBackPage);
  var categoryPerformancePage = CategoryPerformance(onBackPage: onBackPage);
  return ModuleMenu(
      name: 'Reports',
      icon: Icon(Icons.data_saver_off_outlined,
          color: Theme.of(context).colorScheme.primary),
      link: cashOverviewPage.pageName,
      page: cashOverviewPage,
      roles: [
        'admin'
      ],
      children: [
        ModuleMenu(
          name: 'Cash overview',
          link: cashOverviewPage.pageName,
          icon: Icon(Icons.bar_chart_outlined,
              color: Theme.of(context).colorScheme.primary),
          roles: ['admin'],
          page: cashOverviewPage,
        ),
        ModuleMenu(
          name: 'Invoices overview',
          link: invoiceOverviewPage.pageName,
          icon: Icon(Icons.stacked_bar_chart_outlined,
              color: Theme.of(context).colorScheme.primary),
          roles: ['admin'],
          page: invoiceOverviewPage,
        ),
        ModuleMenu(
          name: 'Sales tracking',
          link: salesCashTrackingPage.pageName,
          icon: Icon(Icons.ssid_chart_outlined,
              color: Theme.of(context).colorScheme.primary),
          roles: ['admin'],
          page: salesCashTrackingPage,
        ),
        ModuleMenu(
          name: 'Product performance',
          link: productPerformancePage.pageName,
          icon: Icon(Icons.trending_up_outlined,
              color: Theme.of(context).colorScheme.primary),
          roles: ['admin'],
          page: productPerformancePage,
        ),
        ModuleMenu(
          name: 'Seller performance',
          link: sellerPerformancePage.pageName,
          icon: Icon(Icons.multiline_chart_outlined,
              color: Theme.of(context).colorScheme.primary),
          roles: ['admin'],
          page: sellerPerformancePage,
        ),
        ModuleMenu(
          name: 'Category overview',
          link: categoryPerformancePage.pageName,
          icon: Icon(Icons.category_outlined,
              color: Theme.of(context).colorScheme.primary),
          roles: ['admin'],
          page: categoryPerformancePage,
        ),
      ]);
}

ModuleMenu _getExpensesMenu(
    {required BuildContext context,
    required OnBackPage onBackPage,
    required OnChangePage onChangePage}) {
  var expenseAllPage =
      ExpenseExpensesPage(onBackPage: onBackPage, onChangePage: onChangePage);

  return ModuleMenu(
      name: 'Expenses',
      icon: Icon(Icons.receipt_long_outlined,
          color: Theme.of(context).colorScheme.primary),
      link: expenseAllPage.pageName,
      page: expenseAllPage,
      roles: [
        '*'
      ],
      children: [
        // ModuleMenu(
        //   name: 'Create',
        //   link: expenseCreatePage.pageName,
        //   icon: Icon(Icons.receipt,color: Theme.of(context).colorScheme.primary),
        //   roles: ['*'],
        //   page: expenseCreatePage,
        // ),
        ModuleMenu(
          name: 'All expenses',
          link: expenseAllPage.pageName,
          icon: Icon(Icons.receipt_outlined,
              color: Theme.of(context).colorScheme.primary),
          roles: ['*'],
          page: expenseAllPage,
        ),
        // ModuleMenu(
        //   name: 'Summary',
        //   link: expenseIndex.pageName,
        //   icon: Icon(Icons.bar_chart_outlined,
        //       color: Theme.of(context).colorScheme.primary),
        //   roles: ['*'],
        //   page: expenseIndex,
        // ),
      ]);
}

ModuleMenu _getDashboardMenu(
    {required BuildContext context,
    required OnBackPage onBackPage,
    required OnChangePage onChangePage}) {
  var dashboardIndex = const DashboardIndexPage();
  return ModuleMenu(
    name: 'Dashboard',
    icon: Icon(
      Icons.dashboard_outlined,
      color: Theme.of(context).colorScheme.primary,
    ),
    link: dashboardIndex.pageName,
    page: dashboardIndex,
    roles: ['admin'],
  );
}

ModuleMenu _getInventoryMenu(
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
      icon: Icon(Icons.inventory_2_outlined,
          color: Theme.of(context).colorScheme.primary),
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
          icon: Icon(Icons.sell_outlined,
              color: Theme.of(context).colorScheme.primary),
          // onClick: () => null,
        ),
        ModuleMenu(
          name: 'Categories',
          link: categoriesPage.pageName,
          roles: ['admin', 'manager'],
          icon: Icon(Icons.category_outlined,
              color: Theme.of(context).colorScheme.primary),
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
          icon: Icon(Icons.receipt_outlined,
              color: Theme.of(context).colorScheme.primary),
          page: purchasePage,
        ),
        ModuleMenu(
          name: 'Transfers',
          link: transfersPage.pageName,
          roles: ['admin', 'manager'],
          icon: Icon(Icons.change_circle_outlined,
              color: Theme.of(context).colorScheme.primary),
          page: transfersPage,
        ),
        ModuleMenu(
          name: 'Summary',
          link: productsSummaryPage.pageName,
          roles: ['admin', 'manager'],
          icon: Icon(Icons.bar_chart_outlined,
              color: Theme.of(context).colorScheme.primary),
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
  var invoicesPage =
      InvoicesPage(onBackPage: onBackPage, onChangePage: onChangePage);
  var receiptsPage =
      SalesCashPage(onBackPage: onBackPage, onChangePage: onChangePage);
  var soldItemsPage =
      SoldItemsPage(onBackPage: onBackPage, onChangePage: onChangePage);
  var ordersPage =
      OrdersPage(onBackPage: onBackPage, onChangePage: onChangePage);
  var customersPage = CustomersPage(onBackPage: onBackPage);
  return ModuleMenu(
    name: 'Point Of Sale',
    icon: Icon(Icons.point_of_sale_outlined,
        color: Theme.of(context).colorScheme.primary),
    link: salesCashRetailPage.pageName,
    page: salesCashRetailPage,
    roles: ['*'],
    children: [
      ModuleMenu(
        name: 'Create retail sale',
        link: salesCashRetailPage.pageName,
        icon: Icon(Icons.storefront_outlined,
            color: Theme.of(context).colorScheme.primary),
        roles: ['*'],
        page: salesCashRetailPage,
      ),
      ModuleMenu(
        name: 'Create wholesale',
        link: '/sales/cash',
        icon: Icon(Icons.business_outlined,
            color: Theme.of(context).colorScheme.primary),
        roles: ['*'],
        page: salesCashWholePage,
      ),
      ModuleMenu(
        name: 'Create invoice',
        link: invoiceCreatePage.pageName,
        icon: Icon(Icons.add_card_outlined,
            color: Theme.of(context).colorScheme.primary),
        roles: ['*'],
        page: invoiceCreatePage,
      ),
      ModuleMenu(
        name: 'Sold items',
        link: soldItemsPage.pageName,
        icon: Icon(Icons.paste_outlined,
            color: Theme.of(context).colorScheme.primary),
        roles: ['*'],
        page: soldItemsPage,
      ),
      ModuleMenu(
        name: 'Invoices',
        link: invoicesPage.pageName,
        icon: Icon(Icons.receipt_long_outlined,
            color: Theme.of(context).colorScheme.primary),
        roles: ['*'],
        page: invoicesPage,
      ),
      ModuleMenu(
        name: 'Receipts',
        link: receiptsPage.pageName,
        icon: Icon(Icons.receipt_outlined,
            color: Theme.of(context).colorScheme.primary),
        roles: ['*'],
        page: receiptsPage,
      ),
      ModuleMenu(
        name: 'Customers',
        link: customersPage.pageName,
        icon: Icon(Icons.supervised_user_circle_outlined,
            color: Theme.of(context).colorScheme.primary),
        roles: ['*'],
        page: customersPage,
      ),
      ModuleMenu(
        name: 'Orders',
        link: ordersPage.pageName,
        icon: Icon(Icons.local_mall_outlined,
            color: Theme.of(context).colorScheme.primary),
        roles: ['*'],
        page: ordersPage,
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
  initializeSmartStock(
    onGetAppMenu: _onGetModules,
    onGetInitialPage: ({required onBackPage, required onChangePage}) =>
        PurchaseCreatePage(onBackPage: onBackPage),
  );

  // initializeSmartStock(
  //     onGetAppMenu: _getEmptyMenu,
  //     onGetInitialPage: ({required onBackPage, required onChangePage}) =>
  //         PurchaseCreatePage(onBackPage: onBackPage));
}
