import 'dart:convert';

import 'package:bfast/model/raw_response.dart';
import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/util.dart';

import '../../core/services/date.dart';

Future getSoldItems(DateTimeRange range) async {
  var shop = await getActiveShop();
  var from = toSqlDate(range.start);
  var to = toSqlDate(range.end);
  var execute = composeAsync([
    itOrEmptyArray,
    (RawResponse items) => jsonDecode(items.body),
    (app) => httpGetRequest(
        '${shopFunctionsURL(app)}/report/sales/items/?from=$from&to=$to'),
    shopToApp,
  ]);
  return await execute(shop);
}
