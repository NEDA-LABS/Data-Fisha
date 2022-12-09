import 'package:flutter/material.dart';
import 'package:smartstock/core/services/cache_shop.dart';

import 'api_report.dart';

Future getCashSalesOverview(DateTimeRange range, String period) async {
  var shop = await getActiveShop();
  var getOverviewSales = prepareGetOverviewCashSales(shop, period);
  return getOverviewSales(range);
}

Future getInvoiceSalesOverview(DateTimeRange range, String period) async {
  var shop = await getActiveShop();
  var getDailySales = prepareGetOverviewInvoiceSales(shop, period);
  return getDailySales(range);
}

Future getCategoryPerformance(DateTimeRange range) async {
  var shop = await getActiveShop();
  var getDailySales = prepareGetPerformanceReport(shop, 'category');
  return getDailySales(range);
}

Future getSellerPerformance(DateTimeRange range) async {
  var shop = await getActiveShop();
  var getDailySales = prepareGetPerformanceReport(shop, 'seller');
  return getDailySales(range);
}

Future getProductPerformance(DateTimeRange range) async {
  var shop = await getActiveShop();
  var getDailySales = prepareGetPerformanceReport(shop, 'product');
  return getDailySales(range);
}

Future getSalesCashTracking(DateTimeRange range) async {
  var shop = await getActiveShop();
  var getDailySales = prepareGetSalesCashTracking(shop);
  return getDailySales(range);
}