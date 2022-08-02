import 'package:bfast/bfast.dart';
import 'package:bfast/bfast_config.dart';
import 'package:bfastui/adapters/state.dart';
import 'package:bfastui/controllers/navigation.dart';
import 'package:smartstock_pos/shared/local-storage.utils.dart';

class ChooseShopState extends StateAdapter {
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
      var _storage = SmartStockPosLocalStorage();
      await _storage.saveCurrentProjectId(projectId);
      await _storage.saveActiveShop(shop);
      navigateTo('/sales');
      getShops();
    } catch (e) {
      getShops();
      throw e;
    }
  }

  @override
  void onDispose() {
    // TODO: implement onDispose
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
