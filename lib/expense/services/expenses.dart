import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/expense/services/api.dart';

Future getExpenses(startAt, size) async {
  var shop = await getActiveShop();
  var getRemoteExpense = prepareGetExpensesRemote(startAt, size, '');
  return getRemoteExpense(shop);
}

Future deleteExpense(dynamic id) async {
  var shop = await getActiveShop();
  var deleteExpensesRemote = prepareDeleteExpensesRemote(id);
  return deleteExpensesRemote(shop);
}

Future submitExpenses({
  required String date,
  required String name,
  required String category,
  required amount,
  List<Map>? file,
}) async {
  String timer = DateTime.now().toIso8601String();
  var expense = {
    "date": date,
    "timer": timer,
    "category": category,
    "name": name,
    "amount": amount,
    "file": file
  };
  var shop = await getActiveShop();
  var createExpenses = prepareCreateExpensesRemote(expense);
  return createExpenses(shop);
}
