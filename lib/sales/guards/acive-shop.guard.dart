import 'package:bfast/bfast.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../common/storage.dart';
import '../../common/util.dart';
import '../services/stocks.service.dart';

class ActiveShopGuard extends RouteGuard {
  @override
  Future<bool> canActivate(String url, ParallelRoute parallelRoute) async {
    LocalStorage _storage = LocalStorage();
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
