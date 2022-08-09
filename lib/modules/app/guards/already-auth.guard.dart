import 'package:bfast/bfast.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock_pos/modules/sales/services/stocks.service.dart';
import 'package:smartstock_pos/modules/shared/local-storage.utils.dart';
import 'package:smartstock_pos/util.dart';

class AlreadyAuthGuard extends RouteGuard {
  @override
  Future<bool> canActivate(String url, var b) async {
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
