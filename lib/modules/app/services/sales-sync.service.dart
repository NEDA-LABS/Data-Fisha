import 'dart:async';
import 'dart:convert';

import 'package:bfast/bfast.dart';
import 'package:bfast/bfast_config.dart';
import 'package:bfast/controller/cache.dart';
import 'package:flutter/foundation.dart';

class SalesSyncService {
  var shouldRun = true;

  start() {
    Timer.periodic(Duration(seconds: 8), (_) {
      // print("Sales synchronization started!!!!!!");
      if (shouldRun) {
        shouldRun = false;
        run().then((_) {}).catchError((_) {}).whenComplete(() {
          shouldRun = true;
        });
      } else {
        print('another save sales routine runs');
      }
    });
  }

  Future run() async {
    initiateSmartStock();
    await saveSalesAndRemove();
  }

  Future saveSalesAndRemove() async {
    final shops = await getShops();
    for (final shop in shops) {
      try {
        BFast.init(AppCredentials(shop['applicationId'], shop['projectId']),
            shop['projectId']);
        var salesCache = BFast.cache(
            CacheOptions(database: "sales", collection: shop['projectId']));
        List salesKeys = await salesCache.keys();
        for (var key in salesKeys) {
          var sales = await salesCache.get(key);
          if (!(sales is List)) {
            await salesCache.remove(key);
            return;
          } else {
            await compute(saveSaleAndUpdateStock, {"sales": sales, "shop": shop});
            await salesCache.remove(key, true);
            return;
          }
        }
      } catch (err) {
        print(err);
      }
    }
  }

  Future getShops() async {
    try {
      var user = await BFast.auth().currentUser();
      if (user != null && user['shops'] != null && (user['shops'] is List)) {
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
      print(e);
      return [];
    }
  }
}

initiateSmartStock() {
  BFast.init(AppCredentials('smartstock_lb', 'smartstock'));
}

Future saveSaleAndUpdateStock(Map map) async {
  initiateSmartStock();
  var dataToSave = map['sales'].map<Map>((sale) {
    return {
      "body": jsonDecode(sale['body']),
      "method": sale['method'],
      "path": sale['path']
    };
  }).toList();
  await BFast.functions()
      .request(
      '/functions/sales/${map['shop']['projectId']}/${map['shop']['applicationId']}')
      .post({"requests": dataToSave});
}