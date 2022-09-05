import 'dart:convert';

import 'package:smartstock/sales/services/sales_cache.dart';

import '../../core/services/security.dart';

Future saveSales(List sales, String cartId) async {
  List batchs = [];
  for (var sale in sales) {
    var batch = generateUUID();
    sale['cartId'] = cartId;
    sale['batch'] = batch;
    sale['id'] = batch;
    batchs.add(
        {"method": 'POST', "body": jsonEncode(sale), "path": '/sale/cash'});
  }
  return saveSalesLocal(batchs);
}

