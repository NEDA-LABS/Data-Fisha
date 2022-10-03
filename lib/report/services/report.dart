import 'package:flutter/material.dart';
import 'package:smartstock/core/services/cache_shop.dart';

import 'api_report.dart';

Future getDailySalesOverview(DateTimeRange range) async {
  var shop = await getActiveShop();
  var getDailySales = prepareGetOverviewCashSales(shop, 'day');
  return getDailySales(range);
}

Future getMonthlySalesOverview(DateTimeRange range) async {
  var shop = await getActiveShop();
  var getMonthlySales = prepareGetOverviewCashSales(shop, 'month');
  return getMonthlySales(range);
}

Future getYearlySalesOverview(DateTimeRange range) async {
  var shop = await getActiveShop();
  var getMonthlySales = prepareGetOverviewCashSales(shop, 'year');
  return getMonthlySales(range);
}