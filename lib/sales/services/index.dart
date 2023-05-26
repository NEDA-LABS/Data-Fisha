
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/date.dart';
import 'package:smartstock/sales/services/api_index.dart';

Future  getSalesReport(DateTime date) async {
  var shop = await getActiveShop();
  return getSalesSummaryReport(shop, toSqlDate(date));
}