import 'dart:convert';

import 'package:smartstock_pos/shared/local-storage.utils.dart';
import 'package:smartstock_pos/shared/security.utils.dart';

class SalesService {
  SmartStockPosLocalStorage _storage = SmartStockPosLocalStorage();

  Future saveSales(List sales, String cartId) async {
    List batchs = [];
    sales.forEach((sale) {
      var batch = Security.generateUUID();
      sale['cartId'] = cartId;
      sale['batch'] = batch;
      sale['id'] = batch;
      batchs.add({
        "method": 'POST',
        "body": jsonEncode(sale),
        "path": '/classes/sales'
      });
    });
    return await this._storage.saveSales(batchs);
  }
}
