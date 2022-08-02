import 'package:bfast/bfast.dart';
import 'package:bfastui/adapters/router_guard.dart';
import 'package:bfastui/controllers/navigation.dart';
import 'package:smartstock_pos/modules/sales/services/stocks.service.dart';
import 'package:smartstock_pos/shared/local-storage.utils.dart';

class AlreadyAuthGuard extends RouterGuardAdapter {
  @override
  Future<bool> canActivate(String url) async {
    var user = await BFast.auth().currentUser();
    if (user == null) {
      return true;
    } else {
      StockSyncService.stop();
      SmartStockPosLocalStorage _storage = SmartStockPosLocalStorage();
      _storage.removeActiveShop();
      navigateTo('/shop');
      return false;
    }
  }
}
