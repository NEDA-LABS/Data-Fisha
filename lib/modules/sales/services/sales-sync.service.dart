import 'dart:async';
import 'dart:convert';

import 'package:bfast/bfast.dart';
import 'package:bfast/bfast_config.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:smartstock_pos/shared/security.utils.dart';

class SalesSyncService {
  var shouldRun = true;

  start() {
    Timer.periodic(Duration(seconds: 8), (_) async {
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
        var salesCache =
            BFast.cache(database: "sales", collection: shop['projectId']);
        List salesKeys = await salesCache.keys();
        for (var key in salesKeys) {
          var sales = await salesCache.get(key);
          if (!(sales is List)) {
            await salesCache.remove(key);
          } else {
            await compute(
                saveSaleAndUpdateStock, {"sales": sales, "shop": shop});
            await salesCache.remove(key, force: true);
          }
        }
      } catch (err) {
        // throw err;
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
  // print('here we fuck again');
  var dataToSave = map['sales'].map<dynamic>((x){
    var sale = jsonDecode(x["body"]) as Map<String, dynamic>;
    var stock = sale['stock'] as Map<String, dynamic>;
    var sellerObject = sale['userObject'] as Map<String,dynamic>;
    return {
      "soldBy": {
        "username": sellerObject!=null?sellerObject['username']??'': ''
      },
      "id": sale['id']??Security.generateUUID(),
      "date": sale['date'],
      'timer': sale['timer'],
      'product': sale['product']??'',
      'category': sale['category']??'',
      'unit': sale['unit']??'',
      'quantity': sale['quantity']??0,
      'amount': sale['amount']??0,
      'customer': sale['customer']??'',
      'cartId': sale['cartId'],
      'discount': sale['discount']??0,
      'user': sellerObject!=null?sellerObject['username']??'': '',
      'refund': {'amount': 0, 'quantity': 0},
      'sellerObject': {
        'username': sellerObject!=null?sellerObject['username']??'':'',
        'firstname': sellerObject!=null?sellerObject['firstname']??'':'',
        'lastname': sellerObject!=null?sellerObject['lastname']??'':'',
      },
      'channel': sale['channel']??'retail',
      'stock': {
        'id': stock!=null?stock['id']??Security.generateUUID():Security.generateUUID(),
        'retailPrice': stock!=null?stock['retailPrice']??0: 0,
        'wholesalePrice': stock!=null?stock['wholesalePrice']??0: 0,
        'purchase': stock!=null?stock['purchase']??0: 0,
        'supplier': stock!=null?stock['supplier']??'': '',
        'stockable': stock!=null?stock['stockable']??true : true
      },
      'batch': sale['batch'],
      'stockId': sale['stockId'],
    };
  }).toList();
  var projectId = map['shop']['projectId'];
  var appId = map['shop']['applicationId'];
  var url = Uri.parse('https://smartstock-faas.bfast.fahamutech.com/shop/$projectId/$appId/sale/cash');
  var r = await post(
      url,
    headers: {'content-type': 'application/json'},
      body: jsonEncode(dataToSave)
  );
  if(r.statusCode!=200){
    throw Exception(r.body);
  }
  print('done:::push sales');
  // await BFast.functions()
  //     .request(url.toString())
  //         // 'https://${map['shop']['projectId']}-daas.bfast.fahamutech.com/functions/sales')
  //     .post(jsonEncode(dataToSave) as dynamic);
}
