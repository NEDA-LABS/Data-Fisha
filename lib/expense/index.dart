import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock/core/guards/auth.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/expense/pages/categories.dart';
import 'package:smartstock/expense/pages/expenses.dart';
import 'package:smartstock/expense/pages/items.dart';
import 'package:smartstock/sales/guards/active_shop.dart';

class ExpenseModule extends Module {

  ExpenseModule();

  @override
  List<ChildRoute> get routes => [
        ChildRoute(
          '/',
          guards: [AuthGuard(), ActiveShopGuard()],
          child: (_, __) =>
              ExpenseExpensesPage(),
        ),
        ChildRoute(
          '/categories',
          guards: [AuthGuard(), ActiveShopGuard()],
          child: (_, __) => ExpenseCategoriesPage(
          ),
        ),
        ChildRoute(
          '/items',
          guards: [AuthGuard(), ActiveShopGuard()],
          child: (_, __) => ExpenseItemsPage(
          ),
        ),
        ChildRoute(
          '/expenses',
          guards: [AuthGuard(), ActiveShopGuard()],
          child: (_, __) =>
              ExpenseExpensesPage(),
        )
      ];

  @override
  List<Bind> get binds => [];
}
