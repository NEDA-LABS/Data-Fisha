import 'package:flutter/material.dart';
import 'package:smartstock/account/pages/profile.dart';
import 'package:smartstock/account/pages/users.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/dashboard/pages/index.dart';
import 'package:smartstock/expense/pages/expenses_page.dart';
import 'package:smartstock/initializer.dart';
import 'package:smartstock/report/pages/sales_cash_overview.dart';
import 'package:smartstock/report/pages/sales_tracking.dart';
import 'package:smartstock/report/pages/sales_category_performance.dart';
import 'package:smartstock/report/pages/sales_invoice_overview.dart';
import 'package:smartstock/report/pages/sales_product_performance.dart';
import 'package:smartstock/report/pages/sales_seller_performance.dart';
import 'package:smartstock/sales/pages/customers_page.dart';
import 'package:smartstock/sales/pages/invoices_page.dart';
import 'package:smartstock/sales/pages/orders_page.dart';
import 'package:smartstock/sales/pages/receipts_page.dart';
import 'package:smartstock/sales/pages/register_sale_page.dart';
import 'package:smartstock/sales/pages/sold_items_page.dart';
import 'package:smartstock/stocks/pages/categories.dart';
import 'package:smartstock/stocks/pages/index.dart';
import 'package:smartstock/stocks/pages/products_page.dart';
import 'package:smartstock/stocks/pages/purchase_create_page.dart';
import 'package:smartstock/stocks/pages/purchases_page.dart';
import 'package:smartstock/stocks/pages/suppliers.dart';
import 'package:smartstock/stocks/pages/transfers_page.dart';

List<ModuleMenu> _onGetModules({
  required BuildContext context,
  required OnChangePage onChangePage,
  required OnBackPage onBackPage,
}) {
  return [
    _getDashboardMenu(
        context: context, onBackPage: onBackPage, onChangePage: onChangePage),
    _getInventoryMenu(
        context: context, onBackPage: onBackPage, onChangePage: onChangePage),
    // _getSalesMenu(
    //     context: context, onBackPage: onBackPage, onChangePage: onChangePage),
    // _getExpensesMenu(
    //     context: context, onBackPage: onBackPage, onChangePage: onChangePage),
    // _getReportMenu(
    //     context: context, onBackPage: onBackPage, onChangePage: onChangePage),
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
    name: 'My profile',
    icon: Icon(Icons.supervised_user_circle_outlined,
        color: Theme.of(context).colorScheme.primary),
    link: profilePage.pageName,
    page: profilePage,
    roles: ['*'],
    // children: [
    //   ModuleMenu(
    //     name: 'My profile',
    //     link: profilePage.pageName,
    //     icon: Icon(Icons.person_outline,
    //         color: Theme.of(context).colorScheme.primary),
    //     roles: ["*"],
    //     page: profilePage,
    //   ),
    //   ModuleMenu(
    //     name: 'Users',
    //     link: usersPage.pageName,
    //     icon: Icon(Icons.groups_outlined,
    //         color: Theme.of(context).colorScheme.primary),
    //     roles: ["admin", 'manager'],
    //     page: usersPage,
    //   )
    // ],
  );
}

// ModuleMenu _getReportMenu(
//     {required BuildContext context,
//     required OnBackPage onBackPage,
//     required OnChangePage onChangePage}) {
//   var cashOverviewPage = OverviewCashSales(onBackPage: onBackPage);
//   var invoiceOverviewPage = OverviewInvoiceSales(onBackPage: onBackPage);
//   var salesCashTrackingPage = SalesTrackingPage(onBackPage: onBackPage);
//   var productPerformancePage = ProductPerformance(onBackPage: onBackPage);
//   var sellerPerformancePage = SellerPerformance(onBackPage: onBackPage);
//   var categoryPerformancePage = CategoryPerformance(onBackPage: onBackPage);
//   return ModuleMenu(
//       name: 'Reports',
//       icon: Icon(Icons.data_saver_off_outlined,
//           color: Theme.of(context).colorScheme.primary),
//       link: cashOverviewPage.pageName,
//       page: cashOverviewPage,
//       roles: [
//         'admin'
//       ],
//       children: [
//         ModuleMenu(
//           name: 'Cash overview',
//           link: cashOverviewPage.pageName,
//           icon: Icon(Icons.bar_chart_outlined,
//               color: Theme.of(context).colorScheme.primary),
//           roles: ['admin'],
//           page: cashOverviewPage,
//         ),
//         ModuleMenu(
//           name: 'Invoices overview',
//           link: invoiceOverviewPage.pageName,
//           icon: Icon(Icons.stacked_bar_chart_outlined,
//               color: Theme.of(context).colorScheme.primary),
//           roles: ['admin'],
//           page: invoiceOverviewPage,
//         ),
//         ModuleMenu(
//           name: 'Sales tracking',
//           link: salesCashTrackingPage.pageName,
//           icon: Icon(Icons.ssid_chart_outlined,
//               color: Theme.of(context).colorScheme.primary),
//           roles: ['admin'],
//           page: salesCashTrackingPage,
//         ),
//         ModuleMenu(
//           name: 'Product performance',
//           link: productPerformancePage.pageName,
//           icon: Icon(Icons.trending_up_outlined,
//               color: Theme.of(context).colorScheme.primary),
//           roles: ['admin'],
//           page: productPerformancePage,
//         ),
//         ModuleMenu(
//           name: 'Seller performance',
//           link: sellerPerformancePage.pageName,
//           icon: Icon(Icons.multiline_chart_outlined,
//               color: Theme.of(context).colorScheme.primary),
//           roles: ['admin'],
//           page: sellerPerformancePage,
//         ),
//         ModuleMenu(
//           name: 'Category overview',
//           link: categoryPerformancePage.pageName,
//           icon: Icon(Icons.category_outlined,
//               color: Theme.of(context).colorScheme.primary),
//           roles: ['admin'],
//           page: categoryPerformancePage,
//         ),
//       ]);
// }

// ModuleMenu _getExpensesMenu(
//     {required BuildContext context,
//     required OnBackPage onBackPage,
//     required OnChangePage onChangePage}) {
//   var expenseAllPage =
//       ExpensesPage(onBackPage: onBackPage, onChangePage: onChangePage);
//
//   return ModuleMenu(
//       name: 'Expenses',
//       icon: Icon(Icons.receipt_long_outlined,
//           color: Theme.of(context).colorScheme.primary),
//       link: expenseAllPage.pageName,
//       page: expenseAllPage,
//       roles: [
//         '*'
//       ],
//       children: [
//         // ModuleMenu(
//         //   name: 'Create',
//         //   link: expenseCreatePage.pageName,
//         //   icon: Icon(Icons.receipt,color: Theme.of(context).colorScheme.primary),
//         //   roles: ['*'],
//         //   page: expenseCreatePage,
//         // ),
//         ModuleMenu(
//           name: 'All expenses',
//           link: expenseAllPage.pageName,
//           icon: Icon(Icons.receipt_outlined,
//               color: Theme.of(context).colorScheme.primary),
//           roles: ['*'],
//           page: expenseAllPage,
//         ),
//         // ModuleMenu(
//         //   name: 'Summary',
//         //   link: expenseIndex.pageName,
//         //   icon: Icon(Icons.bar_chart_outlined,
//         //       color: Theme.of(context).colorScheme.primary),
//         //   roles: ['*'],
//         //   page: expenseIndex,
//         // ),
//       ]);
// }

ModuleMenu _getDashboardMenu(
    {required BuildContext context,
    required OnBackPage onBackPage,
    required OnChangePage onChangePage}) {
  var dashboardIndex =
      DashboardIndexPage(onChangePage: onChangePage, onBackPage: onBackPage);
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
  var purchaseCreate = PurchaseCreatePage(onBackPage: onBackPage);
  // var productsSummaryPage =
  //     StocksIndexPage(onBackPage: onBackPage, onChangePage: onChangePage);
  var productsVendors =
      SuppliersPage(onBackPage: onBackPage, onChangePage: onChangePage);
  return ModuleMenu(
    name: 'Offset',
    icon: Icon(Icons.inventory_2_outlined,
        color: Theme.of(context).colorScheme.primary),
    link: purchaseCreate.pageName,
    page: purchaseCreate,
    roles: ['admin', 'manager'],
    children: [
      ModuleMenu(
        name: 'Create',
        link: purchaseCreate.pageName,
        roles: ['admin', 'manager'],
        page: purchaseCreate,
        icon: Icon(Icons.add_shopping_cart,
            color: Theme.of(context).colorScheme.primary),
        // onClick: () => null,
      ),
      // ModuleMenu(
      //   name: 'Categories',
      //   link: productsPage.pageName,
      //   roles: ['admin', 'manager'],
      //   page: productsPage,
      //   icon: Icon(Icons.sell_outlined,
      //       color: Theme.of(context).colorScheme.primary),
      //   // onClick: () => null,
      // ),
      ModuleMenu(
        name: 'Categories',
        link: categoriesPage.pageName,
        roles: ['admin', 'manager'],
        icon: Icon(Icons.category_outlined,
            color: Theme.of(context).colorScheme.primary),
        page: categoriesPage,
      ),
      ModuleMenu(
          name: 'Pickers',
          link: productsVendors.pageName,
          roles: ['admin', 'manager'],
          icon: Icon(
            Icons.support_agent_sharp,
            color: Theme.of(context).colorScheme.primary,
          ),
          page: productsVendors),
      ModuleMenu(
        name: 'All offsets',
        link: purchasePage.pageName,
        roles: ['admin', 'manager'],
        icon: Icon(Icons.receipt_outlined,
            color: Theme.of(context).colorScheme.primary),
        page: purchasePage,
      ),
      // ModuleMenu(
      //   name: 'Transfers',
      //   link: transfersPage.pageName,
      //   roles: ['admin', 'manager'],
      //   icon: Icon(Icons.change_circle_outlined,
      //       color: Theme.of(context).colorScheme.primary),
      //   page: transfersPage,
      // ),
      // ModuleMenu(
      //   name: 'Summary',
      //   link: productsSummaryPage.pageName,
      //   roles: ['admin', 'manager'],
      //   icon: Icon(Icons.bar_chart_outlined,
      //       color: Theme.of(context).colorScheme.primary),
      //   page: productsSummaryPage,
      // ),
    ],
  );
}

ModuleMenu _getSalesMenu(
    {required OnBackPage onBackPage,
    required OnChangePage onChangePage,
    required BuildContext context}) {
  var registerSalePage = RegisterSalePage(onBackPage: onBackPage);
  // var invoiceCreatePage = InvoiceSalePage(onBackPage: onBackPage);
  var invoicesPage =
      InvoicesPage(onBackPage: onBackPage, onChangePage: onChangePage);
  var receiptsPage =
      ReceiptsPage(onBackPage: onBackPage, onChangePage: onChangePage);
  var soldItemsPage =
      SoldItemsPage(onBackPage: onBackPage, onChangePage: onChangePage);
  var ordersPage =
      OrdersPage(onBackPage: onBackPage, onChangePage: onChangePage);
  var customersPage = CustomersPage(onBackPage: onBackPage);
  return ModuleMenu(
    name: 'Disburse',
    icon: Icon(Icons.point_of_sale_outlined,
        color: Theme.of(context).colorScheme.primary),
    link: registerSalePage.pageName,
    page: registerSalePage,
    roles: ['*'],
    children: [
      ModuleMenu(
        name: 'Create',
        link: registerSalePage.pageName,
        icon: Icon(Icons.add_shopping_cart,
            color: Theme.of(context).colorScheme.primary),
        roles: ['*'],
        page: registerSalePage,
      ),
      // ModuleMenu(
      //   name: 'Create wholesale',
      //   link: '/sales/cash',
      //   icon: Icon(Icons.business_outlined,
      //       color: Theme.of(context).colorScheme.primary),
      //   roles: ['*'],
      //   page: salesCashWholePage,
      // ),
      // ModuleMenu(
      //   name: 'Create invoice',
      //   link: invoiceCreatePage.pageName,
      //   icon: Icon(Icons.add_card_outlined,
      //       color: Theme.of(context).colorScheme.primary),
      //   roles: ['*'],
      //   page: invoiceCreatePage,
      // ),
      ModuleMenu(
        name: 'Disbursed wastes',
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
      // ModuleMenu(
      //   name: 'Orders',
      //   link: ordersPage.pageName,
      //   icon: Icon(Icons.local_mall_outlined,
      //       color: Theme.of(context).colorScheme.primary),
      //   roles: ['*'],
      //   page: ordersPage,
      // ),
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
    // onGetInitialPage: ({required onBackPage, required onChangePage}) =>
    //     PurchaseCreatePage(onBackPage: onBackPage),
  );

  // initializeSmartStock(
  //     onGetAppMenu: _getEmptyMenu,
  //     onGetInitialPage: ({required onBackPage, required onChangePage}) =>
  //         PurchaseCreatePage(onBackPage: onBackPage));
}
