import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/date.dart';
import 'package:smartstock/dashboard/services/api_dashboard.dart';

Future getCenterDashboardData(DateTime date) async {
  var shop = await getActiveShop();
  return getDashboardSummary(shop, toSqlDate(date));
}
