import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/date.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/expense/services/api.dart';

Future getExpenses(startAt, size) async {
  var shop = await getActiveShop();
  var getRemoteExpense = prepareGetExpensesRemote(startAt, size, '');
  return getRemoteExpense(shop);
}

Future<List> _carts2Expenses(List carts) async {
  String date = toSqlDate(DateTime.now());
  String timer = DateTime.now().toIso8601String();
  return carts.map((cart) {
    return {
      "date": date,
      "timer": timer,
      "category": cart.product["category"],
      "name": cart.product["name"],
      "amount": doubleOrZero(cart.product["amount"]) * cart.quantity
    };
  }).toList();
}

Future Function(List, String, dynamic) prepareOnSubmitExpenses(context) {
  return (List carts, String customer, discount) async {
    var shop = await getActiveShop();
    var expenses = await _carts2Expenses(carts);
    var createExpenses = prepareCreateExpensesRemote(expenses);
    return createExpenses(shop);
  };
}
