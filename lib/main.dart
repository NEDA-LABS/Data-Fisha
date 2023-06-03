import 'package:flutter/material.dart';
import 'package:smartstock/account/pages/index.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/dashboard/pages/index.dart';
import 'package:smartstock/expense/pages/index.dart';
import 'package:smartstock/index.dart';
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
      icon: const Icon(Icons.dashboard),
      link: '/dashboard/',
      page: dashboardIndex,
      onClick: () => null,
      roles: ['admin'],
    ),
    ModuleMenu(
      name: 'Point Of Sale',
      icon: const Icon(Icons.point_of_sale),
      link: '/sales/',
      page: salesIndex,
      onClick: () => null,
      roles: ['*'],
    ),
    ModuleMenu(
      name: 'Stocks',
      icon: const Icon(Icons.inventory),
      link: '/stock/',
      page: stockIndex,
      onClick: () => null,
      roles: ['admin', 'manager'],
    ),
    ModuleMenu(
      name: 'Expenses',
      icon: const Icon(Icons.receipt_long_rounded),
      link: '/expense/',
      page: expenseIndex,
      onClick: () => null,
      roles: ['*'],
    ),
    ModuleMenu(
      name: 'Reports',
      icon: const Icon(Icons.data_saver_off),
      link: '/report/',
      page: reportIndex,
      onClick: () => null,
      roles: ['admin'],
    ),
    ModuleMenu(
      name: 'Account',
      icon: const Icon(Icons.supervised_user_circle),
      link: '/account/',
      page: accountIndex,
      onClick: () => null,
      roles: ['*'],
    ),
  ];
}

// Widget _onGetInitialModule({
//   required OnChangePage onChangePage,
//   required OnBackPage onBackPage,
// }) {
//   return const DashboardIndexPage();
// }

void main() {
  startSmartStock(
    onGetModulesMenu: _onGetModules,
    // onGetInitialModule: _onGetInitialModule,
  );
}
