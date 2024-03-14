import 'dart:async';

import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/services/api.dart';

Future getDashboardSummary(shop, date) async {
  var postHttp =
      prepareHttpPostRequest({'name': 'total_purchase_item_quantity'});
  var response = await postHttp(
      '${shopFunctionsURL(shopToApp(shop))}/report/custom?date=$date');
  return response;
}
