import 'package:bfast/bfast.dart';
import 'package:bfastui/adapters/router.dart';
import 'package:bfastui/bfastui.dart';
import 'package:smartstock_pos/modules/sales/services/stocks.service.dart';
import 'package:smartstock_pos/shared/local-storage.utils.dart';

class ActiveShopGuard extends BFastUIRouterGuard {
  @override
  Future<bool> canActivate(String url) async {
    SmartStockPosLocalStorage _storage = SmartStockPosLocalStorage();
    var user = await BFast.auth().currentUser();
    var shop = await _storage.getActiveShop();
    if (shop != null && user != null) {
      StockSyncService.run();
      return true;
    } else {
      StockSyncService.stop();
      BFastUI.navigateTo('/shop');
      return false;
    }
  
  }
}
