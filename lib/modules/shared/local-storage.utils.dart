import 'dart:convert';

import 'package:bfast/adapter/cache.dart';
import 'package:bfast/bfast.dart';
import 'package:smartstock_pos/modules/shared/security.utils.dart';
import 'package:smartstock_pos/util.dart';

class SmartStockPosLocalStorage {
  CacheAdapter smartStockCache =
      BFast.cache(database: 'smartstock', collection: 'config');

  Future saveActiveShop(var shop) async {
    var response = await this.smartStockCache.set('activeShop', shop, dtl: 7);
    return response;
  }

  Future getCurrentProjectId() async {
    return await this.smartStockCache.get<String>('cPID');
  }

  Future saveCurrentProjectId(String projectId) async {
    return await this.smartStockCache.set<String>('cPID', projectId, dtl: 7);
  }

  Future getActiveShop() async {
    var response = await this.smartStockCache.get('activeShop');
    if (response != null) {
      return response;
    } else {
      throw {"message": 'No Active Shop'};
    }
  }

  Future getActiveUser() async {
    return await BFast.auth().currentUser();
  }

  Future<dynamic> saveSales(List batchs) async {
    var activeShop = await this.getActiveShop();
    await BFast.cache(database: 'sales', collection: activeShop['projectId'])
        .set(Security.generateUUID(), batchs, dtl: 720);
  }

  Future<List<dynamic>> getSales() async {
    var shop = await this.getActiveShop();
    var stocksCache =
        BFast.cache(database: 'sales', collection: shop['projectId']);
    return await stocksCache.get<List<dynamic>>('all');
  }

  Future clearSmartStockCache() async {
    return await this.smartStockCache.clearAll();
  }

  Future saveActiveUser(var user) async {
    try {
      return await BFast.auth().setCurrentUser(user);
    } catch (e) {
      print('Fail to set user');
      throw e;
    }
  }

  Future removeActiveShop() async {
    var response = await this.smartStockCache.set('activeShop', '');
    return response;
  }

  Future removeActiveUser() async {
    return await BFast.auth().setCurrentUser(null);
  }

  Future removeStocks() async {
    var shop = await this.getActiveShop();
    return await BFast.cache(database: 'stocks', collection: shop['projectId'])
        .clearAll();
  }

  Future<List<dynamic>> getStocks() async {
    var shop = await this.getActiveShop();
    var stocksCache =
        BFast.cache(database: 'stocks', collection: shop['projectId']);
    List stocks = await stocksCache.get<List<dynamic>>('all');
    List _stocks = jsonDecode(jsonEncode(stocks)) as List;
    print(_stocks.length);
    return _stocks.map((stock) {
      stock['quantity'] = getStockQuantity(stock: stock);
      return stock;
    }).toList();
  }

  Future saveStocks(List<dynamic> stocks) async {
    var shop = await this.getActiveShop();
    var stocksCache =
        BFast.cache(database: 'stocks', collection: shop['projectId']);
    return await stocksCache.set('all', stocks, dtl: 360);
  }

  Future saveStock(var stock) async {
    return null;
  }

  Future<List<dynamic>> getCustomers() async {
    var shop = await this.getActiveShop();
    var customersCache =
        BFast.cache(database: 'customers', collection: shop['projectId']);
    List<String> customersKey = await customersCache.keys();
    const customers = [];
    for (String key in customersKey) {
      customers.add(await customersCache.get(key));
    }
    return customers;
  }

  Future<dynamic> saveCustomer(var customer) async {
    var shop = await this.getActiveShop();
    var customersCache =
        BFast.cache(database: 'customers', collection: shop['projectId']);
    return await customersCache.set(customer['displayName'], customer,
        dtl: 360);
  }
}
