import 'package:flutter/material.dart';
import 'package:smartstock/account/pages/index.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/dashboard/pages/index.dart';
import 'package:smartstock/expense/pages/index.dart';
import 'package:smartstock/initializer.dart';
import 'package:smartstock/report/pages/index.dart';
import 'package:smartstock/sales/pages/index.dart';
import 'package:smartstock/stocks/pages/index.dart';

List<ModuleMenu> _onGetModules({
  required BuildContext context,
  required OnChangePage onChangePage,
  required OnBackPage onBackPage,
}) {
  var dashboardIndex = const DashboardIndexPage();
  var reportIndex = ReportIndexPage(
    onChangePage: onChangePage,
    onBackPage: onBackPage,
  );
  var salesIndex = SalesPage(
    onChangePage: onChangePage,
    onBackPage: onBackPage,
  );
  var stockIndex = StocksIndexPage(
    onChangePage: onChangePage,
    onBackPage: onBackPage,
  );
  var expenseIndex = ExpenseIndexPage(
    onChangePage: onChangePage,
    onBackPage: onBackPage,
  );
  var accountIndex = ProfileIndexPage(
    onChangePage: onChangePage,
    onBackPage: onBackPage,
  );
  return [
    ModuleMenu(
      name: 'Dashboard',
      icon: Icon(
        Icons.dashboard,
        color: Theme.of(context).colorScheme.primary,
      ),
      link: '/dashboard/',
      page: dashboardIndex,
      onClick: () => null,
      roles: ['admin'],
    ),
    ModuleMenu(
      name: 'Point Of Sale',
      icon: Icon(Icons.point_of_sale,
          color: Theme.of(context).colorScheme.primary),
      link: '/sales/',
      page: salesIndex,
      onClick: () => null,
      roles: ['*'],
    ),
    ModuleMenu(
      name: 'Stocks',
      icon: Icon(Icons.inventory, color: Theme.of(context).colorScheme.primary),
      link: '/stock/',
      page: stockIndex,
      onClick: () => null,
      roles: ['admin', 'manager'],
    ),
    ModuleMenu(
      name: 'Expenses',
      icon: Icon(Icons.receipt_long_rounded,
          color: Theme.of(context).colorScheme.primary),
      link: '/expense/',
      page: expenseIndex,
      onClick: () => null,
      roles: ['*'],
    ),
    ModuleMenu(
      name: 'Reports',
      icon: Icon(Icons.data_saver_off,
          color: Theme.of(context).colorScheme.primary),
      link: '/report/',
      page: reportIndex,
      onClick: () => null,
      roles: ['admin'],
    ),
    ModuleMenu(
      name: 'Account',
      icon: Icon(Icons.supervised_user_circle,
          color: Theme.of(context).colorScheme.primary),
      link: '/account/',
      page: accountIndex,
      onClick: () => null,
      roles: ['*'],
    ),
  ];
}

void main() {
  initializeSmartStock(onGetModulesMenu: _onGetModules);
  //
  // initializeSmartStock(
  //     onGetModulesMenu: _onGetModules,
  //     onGetInitialModule: ({required onBackPage, required onChangePage}) =>
  //         SalesCashWhole(onBackPage: onBackPage));
}
