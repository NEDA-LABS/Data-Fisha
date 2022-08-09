import 'package:bfast/bfast.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock_pos/modules/sales/services/stocks.service.dart';
import 'package:smartstock_pos/modules/shared/local-storage.utils.dart';
import 'package:smartstock_pos/util.dart';

class ActiveShopGuard extends RouteGuard {
  @override
  Future<bool> canActivate(String url, ParallelRoute parallelRoute) async {
    SmartStockPosLocalStorage _storage = SmartStockPosLocalStorage();
    var user = await BFast.auth().currentUser();
    var shop = await _storage.getActiveShop();
    if (shop != null && user != null) {
      StockSyncService.run();
      return true;
    } else {
      StockSyncService.stop();
      navigateTo('/shop');
      return false;
    }
  }
}
