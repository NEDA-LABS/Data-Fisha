import 'package:flutter/material.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/cache_user.dart';
import 'package:smartstock/core/services/util.dart';

class ChooseShopState extends ChangeNotifier {
  // var activeShop;
  List shops = [];

  Future getShops() async {
    try {
      var user = await getLocalCurrentUser();
      shops = [];
      user['shops'].forEach((element) {
        shops.add(element);
      });
      shops.add({
        "businessName": user['businessName'],
        "projectId": user['projectId'],
        "applicationId": user['applicationId'],
        "projectUrlId": user['projectUrlId'],
        "settings": user['settings'],
        "street": user['street'],
        "country": user['country'],
        "region": user['region']
      });
      return shops;
    } catch (e) {
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future setCurrentShop(var shop) async {
    try {
      String? projectId = shop["projectId"];
      // updateCurrentShop(shop);
      shops = [];
      notifyListeners();
      await saveShopId(projectId);
      await saveActiveShop(shop);
      navigateTo('/sales/');
      getShops();
    } catch (e) {
      getShops();
      rethrow;
    }
  }
}
