import 'package:flutter/material.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/helpers/util.dart';

import '../../core/services/date.dart';

Future getSoldItems(DateTimeRange range) async {
  var shop = await getActiveShop();
  var from = toSqlDate(range.start);
  var to = toSqlDate(range.end);
  var execute = composeAsync([
    itOrEmptyArray,
    (app) => httpGetRequest(
        '${shopFunctionsURL(app)}/report/sales/items/?from=$from&to=$to'),
    shopToApp,
  ]);
  return await execute(shop);
}
