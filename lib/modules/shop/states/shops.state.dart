import 'package:bfast/bfast.dart';
import 'package:bfast/bfast_config.dart';
import 'package:bfastui/adapters/state.dart';
import 'package:bfastui/bfastui.dart';
import 'package:smartstock_pos/shared/local-storage.utils.dart';

class ChooseShopState extends BFastUIState {
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
      String appId = shop["applicationId"];
      String projectId = shop["projectId"];
      BFast.int(AppCredentials(appId, projectId), projectId);
      shops = [];
      notifyListeners();
      var _storage = SmartStockPosLocalStorage();
      await _storage.saveCurrentProjectId(projectId);
      await _storage.saveActiveShop(shop);
      BFastUI.navigateTo('/sales');
      getShops();
    } catch (e) {
      getShops();
      throw e;
    }
  }
}
