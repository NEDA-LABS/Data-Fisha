import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/services/date.dart';
import 'package:smartstock/core/services/util.dart';

prepareGetOverviewCashSales(shop, type) {
  return (DateTimeRange range) async {
    var from = toSqlDate(range.start);
    var to = toSqlDate(range.end);
    var execute = composeAsync([
      itOrEmptyArray,
      (app) => httpGetRequest(
          '${shopFunctionsURL(app)}/report/sales/overview/cash/$type?from=$from&to=$to'),
      shopToApp,
    ]);
    return await execute(shop);
  };
}

prepareGetOverviewInvoiceSales(shop, type) {
  return (DateTimeRange range) async {
    var from = toSqlDate(range.start);
    var to = toSqlDate(range.end);
    var execute = composeAsync([
      itOrEmptyArray,
      (app) => httpGetRequest(
          '${shopFunctionsURL(app)}/report/sales/overview/invoice/$type?from=$from&to=$to'),
      shopToApp,
    ]);
    return await execute(shop);
  };
}

prepareGetPerformanceReport(shop, type) {
  return (DateTimeRange range) async {
    var from = toSqlDate(range.start);
    var to = toSqlDate(range.end);
    var execute = composeAsync([
      itOrEmptyArray,
      (app) => httpGetRequest(
          '${shopFunctionsURL(app)}/report/sales/performance/$type?from=$from&to=$to'),
      shopToApp,
    ]);
    return await execute(shop);
  };
}

prepareGetSalesCashTracking(shop) {
  return (DateTimeRange range) async {
    var from = toSqlDate(range.start);
    var to = toSqlDate(range.end);
    var execute = composeAsync([
      itOrEmptyArray,
      (app) => httpGetRequest(
          '${shopFunctionsURL(app)}/report/sales/track/cash?from=$from&to=$to'),
      shopToApp,
    ]);
    return await execute(shop);
  };
}

prepareGetOverviewExpenses(shop, type) {
  return (DateTimeRange range) async {
    var from = toSqlDate(range.start);
    var to = toSqlDate(range.end);
    var execute = composeAsync([
      itOrEmptyArray,
      (app) => httpGetRequest(
          '${shopFunctionsURL(app)}/report/expenses/overview/$type?from=$from&to=$to'),
      shopToApp,
    ]);
    return await execute(shop);
  };
}

prepareGetDistributionExpenses(shop, type) {
  return (DateTimeRange range) async {
    var from = toSqlDate(range.start);
    var to = toSqlDate(range.end);
    var execute = composeAsync([
      itOrEmptyArray,
      (app) => httpGetRequest(
          '${shopFunctionsURL(app)}/report/expenses/distribution/$type?from=$from&to=$to'),
      shopToApp,
    ]);
    return await execute(shop);
  };
}
