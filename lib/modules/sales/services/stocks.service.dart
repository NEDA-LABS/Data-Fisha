import 'package:bfast/bfast.dart';
import 'package:bfast/bfast_config.dart';
import 'package:bfast/controller/cache.dart';

class StockSyncService {
  run() {
    _init();
    _startStockSocket().catchError((err) => print(err));
  }

  _init() {
    BFast.init(AppCredentials('smartstock_lb', 'smartstock'));
  }
}

Future _startStockSocket() async {
  var smartStockCache =
      BFast.cache(CacheOptions(database: 'smartstock', collection: 'config'));
  var shop = await smartStockCache.get('activeShop');
  var event = BFast.functions().event(
    '/stocks',
    onConnect: (_) {
      print('stocks socket connect');
      _getMissedStocks(shop, smartStockCache);
    },
    onDisconnect: (_) => print('stocks socket disconnect'),
  );
  event.listener((data) async {
    print('****************start update stock**************');
    print(data);
    _updateLocalStock(data['body'] != null ? data['body'] : data, shop)
        .catchError((err) => print(err));
  });
  var user = await BFast.auth().currentUser();
  event.emit(
    body: {'you': 'fuck*'},
    auth: user != null && user['objectId'] != null ? user['objectId'] : null,
  );
  event.emit(
    body: {
      'applicationId': shop != null ? shop['applicationId'] : null,
      'projectId': shop != null ? shop['projectId'] : null
    },
    auth: user != null && user['objectId'] != null ? user['objectId'] : null,
  );
}

Future _getMissedStocks(shop, smartStockCache) async {
  if (shop != null &&
      shop['applicationId'] != null &&
      shop['projectId'] != null) {
    var lastUpdate = await smartStockCache.get('lastUpdate');
    if (lastUpdate != null) {
      await _mergeStocks(shop, lastUpdate, smartStockCache);
      return;
    }
    lastUpdate = DateTime.now().toUtc().toString();
    BFast.init(
        AppCredentials(shop['applicationId'], shop['projectId'],
            cache: CacheConfigOptions(false)),
        shop['projectId']);
    var stocks = await BFast.database(shop['projectId'])
        .collection('stocks')
        .getAll(null);
    await BFast.cache(
            CacheOptions(database: 'stocks', collection: shop['projectId']))
        .set('all', stocks);
    await smartStockCache.set('lastUpdate', lastUpdate);
  }
}

Future _mergeStocks(shop, lastUpdate, smartStockCache) async {
  var stocksCache = BFast.cache(
      CacheOptions(database: 'stocks', collection: shop['projectId']));

  BFast.init(AppCredentials(shop['applicationId'], shop['projectId']),
      shop['projectId']);
  var remoteStocks = await BFast.functions()
      .request(
          '/functions/stocks/sync/${shop['projectId']}?lastUpdateTime=$lastUpdate')
      .get();

  if (remoteStocks != null &&
      remoteStocks['lastUpdateTime'] != null &&
      remoteStocks['projectId'] != null &&
      remoteStocks['results'] != null &&
      remoteStocks['results'] is List &&
      remoteStocks['results'].length > 0) {
    var localStocks = await stocksCache.get('all');
    var localStockMap = {};
    if (localStocks != null && localStocks is List) {
      localStocks.forEach((value) {
        localStockMap[value['objectId']] = value;
      });
    }
    if (remoteStocks != null &&
        remoteStocks['results'] != null &&
        remoteStocks['results'] is List) {
      remoteStocks['results'].forEach((value) {
        localStockMap[value['objectId']] = value;
      });
    }
    var newStocks = [];
    localStockMap.keys.forEach((key) {
      newStocks.add(localStockMap[key]);
    });
    await stocksCache.set('all', newStocks);
    await smartStockCache.set(
        'lastUpdate',
        (remoteStocks != null && remoteStocks['lastUpdateTime'] != null)
            ? remoteStocks['lastUpdateTime']
            : null);
    // console.log(localStocks);
    /// console.log(remoteStocks);
  } else {
    // console.log('no new stocks');
  }
}

Future _updateLocalStock(data, shop) async {
  if (shop != null &&
      shop['applicationId'] != null &&
      shop['projectId'] != null &&
      data != null &&
      data['data'] != null) {
    BFast.init(AppCredentials(shop['applicationId'], shop['projectId']),
        shop['projectId']);
    var stocksCache = BFast.cache(
        CacheOptions(database: 'stocks', collection: shop['projectId']));
    List stocks = await stocksCache.get('all');
    var operationType = data['data']['operationType'];
    Map fullDocument = data['data']['fullDocument'];
    Map documentKey = data['data']['documentKey'];
    Map updateDescription = data['data']['updateDescription'];
    switch (operationType) {
      case 'insert':
        fullDocument['objectId'] = fullDocument['_id'];
        fullDocument.remove('_id');
        fullDocument['createdAt'] = fullDocument['_created_at'];
        fullDocument.remove('_created_at');
        fullDocument['createdAt'] = fullDocument['_created_at'];
        fullDocument.remove('_updated_at');
        stocks.add(fullDocument);
        await stocksCache.set('all', stocks);
        return;
      case 'delete':
        await stocksCache.set(
            'all',
            stocks.retainWhere(
                (stock) => stock['objectId'] != documentKey['_id']));
        return;
      case 'update':
        await stocksCache.set('all', stocks.map((stock) {
          if (stock['objectId'] == documentKey['_id']) {
            // updatedFields
            // removedFields
            Map updatedFields = updateDescription['updatedFields'];
            List removedFields = updateDescription['removedFields'];
            if (updateDescription != null && updatedFields != null) {
              if (updatedFields['_updated_at'] != null) {
                stock['updatedAt'] = updatedFields['_updated_at'];
              }
              List updatedFieldKeys = updatedFields.keys.toList();
              updatedFieldKeys
                  .retainWhere((key) => !key.toString().startsWith('_'));
              updatedFieldKeys.forEach((key) {
                stock[key] = updatedFields[key];
              });
            }
            if (updateDescription != null &&
                removedFields != null &&
                removedFields is List) {
              removedFields.forEach((key) {
                stock.remove(key);
              });
            }
            return stock;
          } else {
            return stock;
          }
        }).toList());
        return;
      case 'replace':
        await stocksCache.set('all', stocks.map((stock) {
          if (stock.objectId == documentKey['_id']) {
            return fullDocument;
          } else {
            return stock;
          }
        }));
        return;
      default:
        return;
    }
  }
}
