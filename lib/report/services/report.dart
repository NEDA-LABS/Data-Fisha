import 'package:flutter/material.dart';
import 'package:smartstock/core/services/cache_shop.dart';

import 'api_report.dart';

Future getDailySalesOverview(DateTimeRange range) async {
  var shop = await getActiveShop();
  var getDailySales = prepareGetDailyCashSales(shop);
  return getDailySales(range);
}

Future getMonthlySalesOverview(DateTimeRange range) async {
  var shop = await getActiveShop();
  var getMonthlySales = prepareGetMonthlyCashSales(shop);
  return getMonthlySales(range);
}