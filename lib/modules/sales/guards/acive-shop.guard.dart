import 'package:bfast/bfast.dart';
import 'package:bfastui/adapters/router.dart';
import 'package:bfastui/bfastui.dart';
import 'package:smartstock/shared/local-storage.dart';

class ActiveShopGuard extends BFastUIRouterGuard {
  @override
  Future<bool> canActivate(String url) async {
    SmartStockPosLocalStorage _storage = SmartStockPosLocalStorage();
    var user = await BFast.auth().currentUser();
    var shop = await _storage.getActiveShop();
    if (shop != null && user != null) {
      return true;
    } else {
      BFastUI.navigateTo('/shop');
      return false;
    }
  }
}
