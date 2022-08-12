import 'dart:convert';

import '../../common/storage.dart';
import '../../common/security.dart';

class SalesService {
  LocalStorage _storage = LocalStorage();

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
