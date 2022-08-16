import 'package:bfast/util.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock_pos/common/services/shop_cache.dart';
import 'package:smartstock_pos/common/services/user_cache.dart';
import '../../sales/services/stocks.service.dart';
import '../../common/services/util.dart';

class AlreadyAuthGuard extends RouteGuard {
  @override
  Future<bool> canActivate(String url, var b) async {
    var user = await currentUser();
    return ifDoElse((y) => y == null, (_) => true, (_) {
      StockSyncService.stop();
      removeActiveShop();
      navigateTo('/shop');
      return false;
    })(user);
  }
}
