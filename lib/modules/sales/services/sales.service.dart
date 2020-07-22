import 'dart:convert';

import 'package:smartstock_pos/shared/local-storage.utils.dart';
import 'package:smartstock_pos/shared/security.utils.dart';

class SalesService {
  SmartStockPosLocalStorage _storage = SmartStockPosLocalStorage();

  Future saveSales(List sales, String cartId) async {
    List batchs = [];
    sales.forEach((sale) {
      sale['cartId'] = cartId;
      sale.batch = Security.generateUUID();
      batchs.add({
        "method": 'POST',
        "body": jsonEncode(sale),
        "path": '/classes/sales'
      });
    });
    return await this._storage.saveSales(batchs);
  }
}
