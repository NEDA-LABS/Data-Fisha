import 'dart:convert';

import 'package:bfast/model/raw_response.dart';
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
      (RawResponse items) => jsonDecode(items.body),
      (app) => getRequest(
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
          (RawResponse items) => jsonDecode(items.body),
          (app) => getRequest(
          '${shopFunctionsURL(app)}/report/sales/overview/invoice/$type?from=$from&to=$to'),
      shopToApp,
    ]);
    return await execute(shop);
  };
}