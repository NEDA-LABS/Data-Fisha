import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock_pos/core/services/cache_shop.dart';
import 'package:smartstock_pos/core/services/cache_user.dart';

import '../services/stocks.dart';

class ActiveShopGuard extends RouteGuard {
  @override
  String get redirectTo => '/';

  @override
  Future<bool> canActivate(String path, ParallelRoute route) async {
    var user = await getLocalCurrentUser();
    var shop = await getActiveShop();
    if (shop != null && user != null) {
      StockSyncService.run();
      return true;
    } else {
      StockSyncService.stop();
      return false;
    }
  }
}
