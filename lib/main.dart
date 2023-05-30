import 'package:flutter/material.dart';
import 'package:smartstock/account/pages/ProfileAccountIndex.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/dashboard/pages/index.dart';
import 'package:smartstock/expense/pages/expenses.dart';
import 'package:smartstock/index.dart';
import 'package:smartstock/report/pages/index.dart';
import 'package:smartstock/sales/pages/index.dart';
import 'package:smartstock/stocks/pages/index.dart';

_onNavigate(BuildContext context, Widget page, String routeId) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
        builder: (context) => page, settings: RouteSettings(name: routeId)),
    (route) => route.settings.name != routeId,
  );
}

List<ModuleMenu> _onGetModules({
  required BuildContext context,
  required OnChangePage onChangePage,
  required OnBackPage onBackPage,
  required OnChangeRightDrawer onChangeRightDrawer,
}) {
  var dashboardIndex = DashboardIndexPage();
  var reportIndex = ReportIndexPage();
  var salesIndex =
      SalesPage(onChangePage: onChangePage, onBackPage: onBackPage, onChangeRightDrawer: onChangeRightDrawer);
  var stockIndex = StocksIndexPage();
  var expenseIndex = ExpenseExpensesPage();
  var accountIndex = ProfileIndexPage();
  return [
    ModuleMenu(
      name: 'Dashboard',
      icon: const Icon(Icons.dashboard),
      link: '/dashboard/',
      page: dashboardIndex,
      onClick: () => _onNavigate(context, dashboardIndex, 'r_dashboard'),
      roles: ['admin'],
    ),
    ModuleMenu(
      name: 'Point Of Sale',
      icon: const Icon(Icons.point_of_sale),
      link: '/sales/',
      page: salesIndex,
      onClick: () => _onNavigate(context, salesIndex, 'r_sales'),
      roles: ['*'],
    ),
    ModuleMenu(
      name: 'Stocks',
      icon: const Icon(Icons.inventory),
      link: '/stock/',
      page: stockIndex,
      onClick: () => _onNavigate(context, stockIndex, 'r_stock'),
      roles: ['admin', 'manager'],
    ),
    ModuleMenu(
      name: 'Expenses',
      icon: const Icon(Icons.receipt_long_rounded),
      link: '/expense/',
      page: expenseIndex,
      onClick: () => _onNavigate(context, expenseIndex, 'r_expense'),
      roles: ['*'],
    ),
    ModuleMenu(
      name: 'Reports',
      icon: const Icon(Icons.data_saver_off),
      link: '/report/',
      page: reportIndex,
      onClick: () => _onNavigate(context, reportIndex, 'r_report'),
      roles: ['admin'],
    ),
    ModuleMenu(
      name: 'Account',
      icon: const Icon(Icons.supervised_user_circle),
      link: '/account/',
      page: accountIndex,
      onClick: () => _onNavigate(context, accountIndex, 'r_account'),
      roles: ['*'],
    ),
  ];
}

void main() {
  startSmartStock(
    onGetModulesMenu: _onGetModules,
    coreModules: {
      // '/': (p0) => DashboardModule(onGetModulesMenu: p0),
      // '/dashboard/': (p0) => DashboardModule(onGetModulesMenu: p0),
      // '/account/': (p0) => AccountModule(onGetModulesMenu: p0),
      // '/report/': (p0) => ReportModule(onGetModulesMenu: p0),
      // // '/sales/': (p0) => SalesModule(onGetModulesMenu: p0),
      // '/stock/': (p0) => StockModule(onGetModulesMenu: p0),
      // '/expense/': (p0) => ExpenseModule(onGetModulesMenu: p0),
    },
    // featureModules: {},
  );
}
