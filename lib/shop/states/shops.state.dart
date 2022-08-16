import 'package:flutter/material.dart';
import 'package:smartstock_pos/common/services/shop.dart';
import 'package:smartstock_pos/common/services/user.dart';
import '../../common/services/util.dart';

class ChooseShopState extends ChangeNotifier {
  var activeShop;
  List shops = [];
  Future getShops() async {
    try {
      var user = await currentUser();
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
      throw e;
    }finally{
      notifyListeners();
    }
  }

  Future setCurrentShop(var shop) async {
    try {
      String projectId = shop["projectId"];
      // updateCurrentShop(shop);
      shops = [];
      notifyListeners();
      await saveShopId(projectId);
      await saveActiveShop(shop);
      navigateTo('/sales');
      getShops();
    } catch (e) {
      getShops();
      throw e;
    }
  }
}

// updateCurrentShop(var shop){
//   String appId = shop["applicationId"];
//   String projectId = shop["projectId"];
//   BFast.init(AppCredentials(
//     appId, projectId,
//     databaseURL: 'https://smartstock-faas.bfast.fahamutech.com/shop/$projectId/$appId/v2',
//     functionsURL: 'https://smartstock-faas.bfast.fahamutech.com/shop/$projectId/$appId',
//   ),projectId);
// }
