import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/expense/services/expenses_api.dart';

Future getExpenses(startAt, size) async {
  var shop = await getActiveShop();
  var getRemoteExpense = prepareGetRemoteExpenses(startAt, size, '');
  return getRemoteExpense(shop);
}
