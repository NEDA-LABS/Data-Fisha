import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/date.dart';
import 'package:smartstock/expense/services/api.dart';

getExpensesSummaryReport(DateTime date) async {
  var shop = await getActiveShop();
  var getExpensesSummaryReport = prepareGetExpensesSummaryReport(toSqlDate(date));
  return getExpensesSummaryReport(shop);
}
