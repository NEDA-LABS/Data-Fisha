import 'package:bfast/bfast.dart';
import 'package:bfast/bfast_config.dart';
import 'package:flutter/material.dart';

import '../../common/storage.dart';
import '../../common/util.dart';

class ChooseShopState extends ChangeNotifier {
  var activeShop;
  List shops = [];
  Future getShops() async {
    try {
      var user = await BFast.auth().currentUser();
      this.shops = [];
      user['shops'].forEach((element) {
        this.shops.add(element);
      });
      this.shops.add({
        "businessName": user['businessName'],
        "projectId": user['projectId'],
        "applicationId": user['applicationId'],
        "projectUrlId": user['projectUrlId'],
        "settings": user['settings'],
        "street": user['street'],
        "country": user['country'],
        "region": user['region']
      });
      return this.shops;
    } catch (e) {
      throw e;
    }finally{
      notifyListeners();
    }
  }

  Future setCurrentShop(var shop) async {
    try {
      String projectId = shop["projectId"];
      updateCurrentShop(shop);
      shops = [];
      notifyListeners();
      var _storage = LocalStorage();
      await _storage.saveCurrentProjectId(projectId);
      await _storage.saveActiveShop(shop);
      navigateTo('/sales');
      getShops();
    } catch (e) {
      getShops();
      throw e;
    }
  }
}

updateCurrentShop(var shop){
  String appId = shop["applicationId"];
  String projectId = shop["projectId"];
  BFast.init(AppCredentials(
    appId, projectId,
    databaseURL: 'https://smartstock-faas.bfast.fahamutech.com/shop/$projectId/$appId/v2',
    functionsURL: 'https://smartstock-faas.bfast.fahamutech.com/shop/$projectId/$appId',
  ),projectId);
}
