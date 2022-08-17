// class LocalStorage {
//   CacheAdapter smartStockCache =
//       BFast.cache(database: 'smartstock', collection: 'config');
//
//   Future saveActiveShop(var shop) async {
//     var response = await this.smartStockCache.set('activeShop', shop, dtl: 7);
//     return response;
//   }
//
//   Future getCurrentProjectId() async {
//     return await this.smartStockCache.get<String>('cPID');
//   }
//
//   Future saveCurrentProjectId(String projectId) async {
//     return await this.smartStockCache.set<String>('cPID', projectId, dtl: 7);
//   }
//
//   Future getActiveShop() async {
//     var response = await this.smartStockCache.get('activeShop');
//     if (response != null) {
//       return response;
//     } else {
//       throw {"message": 'No Active Shop'};
//     }
//   }
//
//   Future getActiveUser() async {
//     return await BFast.auth().currentUser();
//   }
//
//

//
//   Future<List<dynamic>> getSales() async {
//     var shop = await this.getActiveShop();
//     var stocksCache =
//         BFast.cache(database: 'sales', collection: shop['projectId']);
//     return await stocksCache.get<List<dynamic>>('all');
//   }
//
//   Future clearSmartStockCache() async {
//     return await this.smartStockCache.clearAll();
//   }
//
//   Future saveActiveUser(var user) async {
//     try {
//       return await BFast.auth().setCurrentUser(user);
//     } catch (e) {
//       print('Fail to set user');
//       throw e;
//     }
//   }
//
//   Future removeActiveShop() async {
//     var response = await this.smartStockCache.set('activeShop', '');
//     return response;
//   }
//
//   Future removeActiveUser() async {
//     return await BFast.auth().setCurrentUser(null);
//   }
//
//   Future removeStocks() async {
//     var shop = await this.getActiveShop();
//     return await BFast.cache(database: 'stocks', collection: shop['projectId'])
//         .clearAll();
//   }
//
//   Future<List<dynamic>> getStocks() async {
//     var shop = await this.getActiveShop();
//     var stocksCache =
//         BFast.cache(database: 'stocks', collection: shop['projectId']);
//     return await stocksCache.get<List<dynamic>>('all');
//   }
//
//   Future saveStocks(List<dynamic> stocks) async {
//     var shop = await this.getActiveShop();
//     var stocksCache =
//         BFast.cache(database: 'stocks', collection: shop['projectId']);
//     return await stocksCache.set('all', stocks, dtl: 360);
//   }
//
//   Future saveStock(var stock) async {
//     return null;
//   }
//
//   Future<List<dynamic>> getCustomers() async {
//     var shop = await this.getActiveShop();
//     var customersCache =
//         BFast.cache(database: 'customers', collection: shop['projectId']);
//     List<String> customersKey = await customersCache.keys();
//     const customers = [];
//     for (String key in customersKey) {
//       customers.add(await customersCache.get(key));
//     }
//     return customers;
//   }
//
//   Future<dynamic> saveCustomer(var customer) async {
//     var shop = await this.getActiveShop();
//     var customersCache =
//         BFast.cache(database: 'customers', collection: shop['projectId']);
//     return await customersCache.set(customer['displayName'], customer,
//         dtl: 360);
//   }
// }
