import 'package:bfast/adapter/transaction.dart';
import 'package:bfast/bfast.dart';
import 'package:bfast/bfast_config.dart';
import 'package:bfast/controller/cache.dart';
import 'package:bfast/model/QueryModel.dart';
import 'package:smartstock_pos/shared/local-storage.utils.dart';

class SalesSyncService {
  SmartStockPosLocalStorage _storage = SmartStockPosLocalStorage();
  SalesSyncService();
  var shouldRun = true;


  run() async {
    print("Sales synchronization started!!!!!!");
    this.initiateSmartStock();
     await saveSalesAndRemove();
  }

  initiateSmartStock() {
   BFast.init(AppCredentials('smartstock_lb', 'smartstock'));
  }

  saveSalesAndRemove() async{
    final shops = await getShops();
    for (final shop in shops) {
      BFast.init(AppCredentials(shop['applicationId'], shop['projectId']));
      var salesCache = BFast.cache(CacheOptions(database: "sales", collection: shop['projectId']));
      final salesKeys = await salesCache.keys();
      for (final key in salesKeys) {
        final sales = await salesCache.get(key);
        final transactionResult = await saveSaleAndUpdateStock(sales, shop, salesCache, key);
        await salesCache.remove(key, true);
        return transactionResult;
      }
    }
  }

 saveSaleAndUpdateStock(List<dynamic> sales, shop, salesCache, key) async{
  var dataToSave = sales.map((sale) => sale['body']);
  await BFast
    .database(shop.projectId)
    .transaction(false)
    .createMany('sales', dataToSave)
    .updateMany<Map>('stocks',
      dataToSave.map((sale){
        return UpdatePayLoad(
          sale['stock']['objectId'],
          {"quantity": {"__op": "Increment", "amount": -sale['quantity']}}
        );
        // return {
        //   'objectId': sale['stock']['objectId'],
        //   'data': {"quantity": {"__op": "Increment", "amount": -sale['quantity']}}
        // };
      }
      ).toList()
    )
    .commit(
      before: (transactionModels) async {
        await prepareSalesCollection(shop);
        transactionModels.retainWhere((value) =>
          value.path.toLowerCase() == '/classes/sales' && value.method.toLowerCase() == 'post');
        for (var sale in transactionModels) {
          final duplicateResults = await BFast.database(shop.projectId)
            .collection('sales')
            .query()
            .find(QueryModel(filter:  {'batch': sale.body['batch']})
            );
          if (duplicateResults != null && duplicateResults is List && duplicateResults.length > 0) {
            transactionModels.retainWhere((value) => value.body.batch != sale.body.batch);
            await salesCache.remove(key, true);
          }
        }
        return transactionModels;
      }
    );
}

prepareSalesCollection(shop) async{
  final inits = await BFast
    .database(shop.projectId)
    .collection('sales')
    .query()
    .find(QueryModel(filter: {
        "n1m": 'prepare'
      })
    );
  if ((inits != null) && inits is List && inits.length > 0) {
    return;
  }
  final t = await BFast.database(shop.projectId)
    .collection('sales')
    .save({'n1m': 'prepare'});
  await BFast.database(shop.projectId)
    .collection('sales')
    .delete(t.objectId);
}
  getShops() async{
  try {
    final user = await BFast.auth().currentUser();

    if (user && user['shops'] && (user['shops'] is List)) {
      final shops = [];

      user['shops'].forEach((element) {
        shops.add(element);
      });

      shops.add({
        'businessName': user['businessName'],
        'projectId': user['projectId'],
        'applicationId': user['applicationId'],
        'projectUrlId': user['projectUrlId'],
        'settings': user['settings'],
        'street': user['street'],
        'country': user['country'],
        'region': user['region']
      });
      return shops;
    }
    return [];
  } catch (e) {
    return [];
  }
}

}
