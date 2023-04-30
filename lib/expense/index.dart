import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock/core/guards/auth.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/expense/pages/categories.dart';
import 'package:smartstock/expense/pages/expenses.dart';
import 'package:smartstock/expense/pages/items.dart';
import 'package:smartstock/sales/guards/active_shop.dart';

class ExpenseModule extends Module {
  final OnGetModulesMenu onGetModulesMenu;

  ExpenseModule({required this.onGetModulesMenu});

  @override
  List<ChildRoute> get routes => [
        ChildRoute(
          '/',
          guards: [AuthGuard(), ActiveShopGuard()],
          child: (_, __) =>
              ExpenseExpensesPage(onGetModulesMenu: onGetModulesMenu),
        ),
        ChildRoute(
          '/categories',
          guards: [AuthGuard(), ActiveShopGuard()],
          child: (_, __) => ExpenseCategoriesPage(
            onGetModulesMenu: onGetModulesMenu,
          ),
        ),
        ChildRoute(
          '/items',
          guards: [AuthGuard(), ActiveShopGuard()],
          child: (_, __) => ExpenseItemsPage(
            onGetModulesMenu: onGetModulesMenu,
          ),
        ),
        ChildRoute(
          '/expenses',
          guards: [AuthGuard(), ActiveShopGuard()],
          child: (_, __) =>
              ExpenseExpensesPage(onGetModulesMenu: onGetModulesMenu),
        )
      ];

  @override
  List<Bind> get binds => [];
}
