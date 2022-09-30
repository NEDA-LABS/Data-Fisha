import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/date.dart';
import 'package:smartstock/dashboard/services/api_dashboard.dart';

Future<Object>  prepareGetDashboardData(DateTime date) async {
  var shop = await getActiveShop();
  return getDashboardSummary(shop, toSqlDate(date));
  // prin/t(r);
  // return r;
}