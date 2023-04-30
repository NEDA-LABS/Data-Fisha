import 'package:flutter/material.dart';
import 'package:smartstock/account/account.dart';
import 'package:smartstock/account/pages/ProfileAccountIndex.dart';
import 'package:smartstock/app_start.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/dashboard/dashboard.dart';
import 'package:smartstock/dashboard/pages/index.dart';
import 'package:smartstock/expense/index.dart';
import 'package:smartstock/expense/pages/index.dart';
import 'package:smartstock/report/pages/index.dart';
import 'package:smartstock/report/report.dart';
import 'package:smartstock/sales/pages/index.dart';
import 'package:smartstock/sales/sales.dart';
import 'package:smartstock/stocks/pages/index.dart';
import 'package:smartstock/stocks/stocks.dart';

_onNavigate(BuildContext context, Widget page, String routeId) {
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
          builder: (context) => page, settings: RouteSettings(name: routeId)),
      (route) => route.settings.name != routeId);
}

List<MenuModel> _onGetModules(BuildContext context) {
  var dashboardIndex = const DashboardIndexPage(onGetModulesMenu: _onGetModules);
  var reportIndex = const ReportIndexPage(onGetModulesMenu: _onGetModules);
  var salesIndex = const SalesPage(onGetModulesMenu: _onGetModules);
  var stockIndex = const StocksIndexPage(onGetModulesMenu: _onGetModules);
  var expenseIndex = const ExpenseIndexPage(onGetModulesMenu: _onGetModules);
  var accountIndex = const ProfileIndexPage(onGetModulesMenu: _onGetModules);
  return [
    MenuModel(
      name: 'Dashboard',
      icon: const Icon(Icons.dashboard),
      link: '/dashboard/',
      onClick: () => _onNavigate(context, dashboardIndex, 'r_dashboard'),
      roles: ['admin'],
    ),
    MenuModel(
        name: 'Reports',
        icon: const Icon(Icons.data_saver_off),
        link: '/report/',
        onClick: () => _onNavigate(context, reportIndex, 'r_report'),
        roles: ['admin'],
    ),
    MenuModel(
      name: 'Point Of Sale',
      icon: const Icon(Icons.point_of_sale),
      link: '/sales/',
      onClick: () => _onNavigate(context, salesIndex, 'r_sales'),
      roles: ['*'],
    ),
    MenuModel(
      name: 'Stocks',
      icon: const Icon(Icons.inventory),
      link: '/stock/',
      onClick: () => _onNavigate(context, stockIndex, 'r_stock'),
      roles: ['admin', 'manager'],
    ),
    MenuModel(
      name: 'Expenses',
      icon: const Icon(Icons.receipt_long_rounded),
      link: '/expense/',
      onClick: () => _onNavigate(context, expenseIndex, 'r_expense'),
      roles: ['*'],
    ),
    MenuModel(
      name: 'Account',
      icon: const Icon(Icons.supervised_user_circle),
      link: '/account/',
      onClick: () => _onNavigate(context, accountIndex, 'r_account'),
      roles: ['*'],
    ),
  ];
}

void main() {
  startSmartStock(onGetModulesMenu: _onGetModules, coreModules: {
    '/': (p0) => DashboardModule(onGetModulesMenu: p0),
    '/dashboard/': (p0) => DashboardModule(onGetModulesMenu: p0),
    '/account/': (p0) => AccountModule(onGetModulesMenu: p0),
    '/report/': (p0) => ReportModule(onGetModulesMenu: p0),
    '/sales/': (p0) => SalesModule(onGetModulesMenu: p0),
    '/stock/': (p0) => StockModule(onGetModulesMenu: p0),
    '/expense/': (p0) => ExpenseModule(onGetModulesMenu: p0),
  });
}
