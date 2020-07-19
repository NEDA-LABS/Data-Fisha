import 'package:bfast/adapter/cache.dart';
import 'package:bfast/bfast.dart';
import 'package:bfast/controller/cache.dart';
import 'package:smartstock_pos/modules/sales/models/stock.model.dart';
import 'package:smartstock_pos/shared/security.utils.dart';

class SmartStockPosLocalStorage {
  CacheAdapter smartStockCache =
      BFast.cache(CacheOptions(database: 'smartstock', collection: 'config'));

  Future saveActiveShop(var shop) async {
    var response = await this.smartStockCache.set('activeShop', shop, 7);
    // BFastUI.getState<ChooseShopState>()?.activeShop = shop;
    return response;
  }

  Future getCurrentProjectId() async {
    return await this.smartStockCache.get<String>('cPID');
  }

  Future saveCurrentProjectId(String projectId) async {
    return await this.smartStockCache.set<String>('cPID', projectId, 7);
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

  // BatchModel[]
  Future<dynamic> saveSales(List batchs) async {
    var activeShop = await this.getActiveShop();
    await BFast.cache(CacheOptions(
            database: 'sales', collection: activeShop['projectId']))
        .set(Security.randomString(12), batchs, 720);
  }

//Future getActiveShop() async{
//var response = await this.smartStockCache.get<ShopI>('activeShop');
//if (response) {
//return response;
//} else {
//throw {message: 'No Active Shop'};
//}
//}

//Future saveActiveShop(var shop) async {
//const response = await this.smartStockCache.set<ShopI>('activeShop', shop, {
//dtl: 7
//});
//this.eventApi.broadcast(SsmEvents.ACTIVE_SHOP_SET);
//return response;
//}
//
//async getCurrentProjectId(): Promise<string> {
//return await this.smartStockCache.get<string>('cPID');
//}
//
//async saveCurrentProjectId(projectId: string): Promise<any> {
//return await this.smartStockCache.set<string>('cPID', projectId, {
//dtl: 7
//});
//}

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
    var response = await this.smartStockCache.set('activeShop', null);
// this.eventApi.broadcast(SsmEvents.ACTIVE_SHOP_REMOVE);
    return response;
  }

  Future removeActiveUser() async {
    return await BFast.auth().setCurrentUser(null);
  }

  Future removeStocks() async {
    var shop = await this.getActiveShop();
    return await BFast.cache(
            CacheOptions(database: 'stocks', collection: shop['projectId']))
        .clearAll();
  }

  Future<List<dynamic>> getStocks() async {
    var shop = await this.getActiveShop();
    var stocksCache = BFast.cache(
        CacheOptions(database: 'stocks', collection: shop['projectId']));
    return await stocksCache.get<List<dynamic>>('all');
  }

  Future saveStocks(List<dynamic> stocks) async {
    var shop = await this.getActiveShop();
    var stocksCache = BFast.cache(
        CacheOptions(database: 'stocks', collection: shop['projectId']));
    return await stocksCache.set('all', stocks, 360);
  }

  Future saveStock(var stock) async {
// const shop = await this.getActiveShop();
// const stocksCache = BFast.cache({database: 'stocks', collection: shop['projectId']});
// return stocksCache.set(stock.objectId, stock);
    return null;
  }

  Future<List<dynamic>> getCustomers() async {
    var shop = await this.getActiveShop();
    var customersCache = BFast.cache(
        CacheOptions(database: 'customers', collection: shop['projectId']));
    List<String> customersKey = await customersCache.keys();
    const customers = [];
    for (String key in customersKey) {
      customers.add(await customersCache.get(key));
    }
    return customers;
  }

  Future<dynamic> saveCustomer(var customer) async {
    var shop = await this.getActiveShop();
    var customersCache = BFast.cache(
        CacheOptions(database: 'customers', collection: shop['projectId']));
    return await customersCache.set(customer['displayName'], customer, 360);
  }
}
