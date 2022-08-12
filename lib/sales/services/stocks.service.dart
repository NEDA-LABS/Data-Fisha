import 'dart:convert';

import 'package:bfast/bfast.dart';
import 'package:bfast/bfast_config.dart';
import 'package:bfast/controller/database.dart';
import 'package:crypto/crypto.dart';

class StockSyncService {
  static DatabaseChangesController changes;
  static bool running = false;

  static run() {
    // _init();
    // _startStockSocket().catchError((err) => print(err));
  }

  static stop() {
    // if (changes != null && changes.close != null) {
    //   changes.close();
    // }
    // running = false;
  }


  static Future _startStockSocket() async {
    if (running == false) {
      try {
        print('Stocks sync initiated');
        print(running);
        var smartStockCache =
            BFast.cache(database: 'smartstock', collection: 'config');
        var shop = await smartStockCache.get('activeShop');
        if (shop == null) {
          throw 'No active shop';
        }
        BFast.init(AppCredentials(shop['applicationId'], shop['projectId']),
            shop['projectId']);
        if (changes == null) {
          changes = BFast.database(shop['projectId'])
              .collection('stocks')
              .query()
              .changes(onConnect: () {
            print('stocks socket connect');
            _getMissedStocks(shop, smartStockCache).catchError((r1) {
              print(r1);
            });
          }, onDisconnect: () {
            print('stocks socket disconnected');
          });
          changes?.addListener((response) {
            print(response);
            _updateLocalStock(response.body, shop).catchError((r2) {
              print('');
            });
          });
        }
        running = true;
      } catch (e) {
        print(e);
        print(':::::::::err connect stock sync::::::::::');
        stop();
      }
    }
  }

  static Future _getMissedStocks(shop, smartStockCache) async {
    if (shop && shop.applicationId && shop.projectId) {
      BFast.init(AppCredentials(shop['applicationId'], shop['projectId']),
          shop['projectId']);
      List<dynamic> localStocks =
          await BFast.cache(database: 'stocks', collection: shop['projectId'])
              .get('all');
      if (localStocks == null) {
        localStocks = [];
      }
      Map<String, dynamic> hashesMap = {};
      localStocks.forEach((value) {
        var datInString = jsonEncode(value);
        print(sha1.convert(utf8.encode(datInString)).toString());
        print("::::::::::sha1::::::::::");
        hashesMap[value['id']] =
            sha1.convert(utf8.encode(datInString)).toString();
      });
      Map<String, dynamic> missed = await BFast.functions(shop.projectId)
          .request(
              'https://${shop['projectId']}-daas.bfast.fahamutech.com/functions/stocks/sync')
          .post(hashesMap);
      hashesMap = {};
      localStocks.forEach((value) {
        hashesMap[value['id']] = value;
      });
      missed.keys.forEach((mKey) {
        if (missed[mKey] == 'DELETE') {
          hashesMap.remove(mKey);
        } else {
          hashesMap[mKey] = missed[mKey];
        }
      });
      localStocks = [];
      hashesMap.keys.forEach((value) {
        localStocks.add(hashesMap[value]);
      });
      await BFast.cache(database: 'stocks', collection: shop['projectId'])
          .set('all', localStocks);
    }
  }

  static Future _updateLocalStock(body, shop) async {
    if (shop != null &&
        shop['applicationId'] != null &&
        shop['projectId'] != null &&
        body != null &&
        body['change'] != null) {
      BFast.init(AppCredentials(shop['applicationId'], shop['projectId']),
          shop['projectId']);
      var stocksCache =
          BFast.cache(database: 'stocks', collection: shop['projectId']);
      var operationType = body['change']['name'];
      Map fullDocument = body['change']['snapshot'];
      List<dynamic> stocks = await stocksCache.get('all');
      switch (operationType) {
        case 'create':
          List<dynamic> _stocks =
              stocks.where((element) => element['id'] != fullDocument['id']).toList();
          _stocks.insert(0, fullDocument);
          stocksCache.set('all', _stocks);
          return;
        case 'delete':
          await stocksCache.set('all',
              stocks.where((element) => element['id'] != fullDocument['id']));
          return;
        case 'update':
          stocks =
              stocks.where((element) => element['id'] != fullDocument['id']).toList();
          stocks.insert(0, fullDocument);
          stocksCache.set('all', stocks);
          return;
        default:
          return;
      }
    }
  }
}
