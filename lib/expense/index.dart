import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock/core/models/external_service.dart';
import 'package:smartstock/expense/pages/categories.dart';
import 'package:smartstock/expense/pages/expenses.dart';
import 'package:smartstock/expense/pages/index.dart';
import 'package:smartstock/expense/pages/items.dart';

class ExpenseModule extends Module {
  final home = ChildRoute(
    '/',
    child: (_, __) => const ExpenseIndexPage(),
  );
  final items = ChildRoute(
    '/categories',
    child: (_, __) => const ExpenseCategoriesPage(),
  );
  final categories = ChildRoute(
    '/items',
    child: (_, __) => const ExpenseItemsPage(),
  );
  final expenses = ChildRoute(
    '/expenses',
    child: (_, __) => const ExpenseExpensesPage(),
  );

  ExpenseModule(List<ExternalService> services);

  @override
  List<ChildRoute> get routes => [home, items, categories, expenses];

  @override
  List<Bind> get binds => [];
}
