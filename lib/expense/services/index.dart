import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/date.dart';
import 'package:smartstock/expense/services/api.dart';

getExpensesSummaryReport(DateTime date) async {
  var shop = await getActiveShop();
  return prepareGetExpensesSummaryReport(shop, toSqlDate(date));
}
