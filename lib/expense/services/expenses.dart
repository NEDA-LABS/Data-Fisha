import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/date.dart';
import 'package:smartstock/expense/services/api.dart';

Future getExpenses(startAt, size) async {
  var shop = await getActiveShop();
  var getRemoteExpense = prepareGetExpensesRemote(startAt, size, '');
  return getRemoteExpense(shop);
}

// Future<List> _carts2Expenses(List carts) async {
//   String date = toSqlDate(DateTime.now());
//   String timer = DateTime.now().toIso8601String();
//   return carts.map((cart) {
//     return {
//       "date": date,
//       "timer": timer,
//       "category": cart.product["category"],
//       "name": cart.product["name"],
//       "amount": doubleOrZero(cart.product["amount"]) * cart.quantity
//     };
//   }).toList();
// }

Future submitExpenses(
    {required String name, required String category, required amount}) async {
  String date = toSqlDate(DateTime.now());
  String timer = DateTime.now().toIso8601String();
  var expense = {
    "date": date,
    "timer": timer,
    "category": category,
    "name": name,
    "amount": amount
  };
  var shop = await getActiveShop();
  var createExpenses = prepareCreateExpensesRemote([expense]);
  return createExpenses(shop);
}
