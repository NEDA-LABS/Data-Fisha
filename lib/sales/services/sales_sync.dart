import 'dart:async';
import 'dart:convert';

import 'package:bfast/options.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:smartstock_pos/core/services/cache_user.dart';
import 'package:smartstock_pos/core/services/util.dart';
import 'package:smartstock_pos/sales/services/sales_cache.dart';

import '../../core/services/security.dart';

class SalesSyncService {
  var shouldRun = true;

  start() {
    Timer.periodic(const Duration(seconds: 8), (_) async {
      // print("Sales synchronization started!!!!!!");
      if (shouldRun) {
        shouldRun = false;
        run().then((_) {}).catchError((_) {}).whenComplete(() {
          shouldRun = true;
        });
      } else {
        if (kDebugMode) {
          print('another save sales routine runs');
        }
      }
    });
  }

  Future run() async {
    // initiateSmartStock();
    await saveSalesAndRemove();
  }

  Future saveSalesAndRemove() async {
    final shops = await getShops();
    for (final shop in shops) {
      try {
        List salesKeys = await getLocalSalesKeys();
        for (var key in salesKeys) {
          var sales = await getLocalSales(key);
          if (sales is! List) {
            await removeLocalSales(key);
          } else {
            await compute(
              saveSaleAndUpdateStock,
              {"sales": sales, "shop": shop},
            );
            await removeLocalSales(key);
          }
        }
      } catch (err) {
        // throw err;
        if (kDebugMode) {
          print(err);
        }
      }
    }
  }

  Future getShops() async {
    try {
      var user = await getLocalCurrentUser();
      if (user != null && user['shops'] != null && (user['shops'] is List)) {
        final shops = [];
        user['shops'].forEach((element) => shops.add(element));
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
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }
}

Future saveSaleAndUpdateStock(Map map) async {
  var dataToSave = map['sales'].map<dynamic>((x) {
    var sale = jsonDecode(x["body"]) as Map<String, dynamic>;
    var stock = sale['stock'] as Map<String, dynamic>;
    var sellerObject = sale['userObject'] as Map<String, dynamic>;
    return {
      "soldBy": {
        "username": sellerObject != null ? sellerObject['username'] ?? '' : ''
      },
      "id": sale['id'] ?? generateUUID(),
      "date": sale['date'],
      'timer': sale['timer'],
      'product': sale['product'] ?? '',
      'category': sale['category'] ?? '',
      'unit': sale['unit'] ?? '',
      'quantity': sale['quantity'] ?? 0,
      'amount': sale['amount'] ?? 0,
      'customer': sale['customer'] ?? '',
      'cartId': sale['cartId'],
      'discount': sale['discount'] ?? 0,
      'user': sellerObject != null ? sellerObject['username'] ?? '' : '',
      'refund': {'amount': 0, 'quantity': 0},
      'sellerObject': {
        'username': sellerObject != null ? sellerObject['username'] ?? '' : '',
        'firstname':
            sellerObject != null ? sellerObject['firstname'] ?? '' : '',
        'lastname': sellerObject != null ? sellerObject['lastname'] ?? '' : '',
      },
      'channel': sale['channel'] ?? 'retail',
      'stock': {
        'id': stock != null ? stock['id'] ?? generateUUID() : generateUUID(),
        'retailPrice': stock != null ? stock['retailPrice'] ?? 0 : 0,
        'wholesalePrice': stock != null ? stock['wholesalePrice'] ?? 0 : 0,
        'purchase': stock != null ? stock['purchase'] ?? 0 : 0,
        'supplier': stock != null ? stock['supplier'] ?? '' : '',
        'stockable': stock != null ? stock['stockable'] ?? true : true
      },
      'batch': sale['batch'],
      'stockId': sale['stockId'],
    };
  }).toList();
  var projectId = map['shop']['projectId'];
  var appId = map['shop']['applicationId'];
  var shopApp = App(applicationId: appId, projectId: projectId);
  var url = Uri.parse('${shopFunctionsURL(shopApp)}/sale/cash');
  var r = await http.post(url,
      headers: getInitialHeaders(), body: jsonEncode(dataToSave));
  if (r.statusCode != 200) {
    throw Exception(r.body);
  }
  if (kDebugMode) {
    print('done:::push sales');
  }
}
