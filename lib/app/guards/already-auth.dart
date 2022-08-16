import 'package:flutter_modular/flutter_modular.dart';
import '../../sales/services/stocks.service.dart';
import '../../common/services/util.dart';

class AlreadyAuthGuard extends RouteGuard {
  @override
  Future<bool> canActivate(String url, var b) async {
    var user = await BFast.auth().currentUser();
    if (user == null) {
      return true;
    } else {
      StockSyncService.stop();
      LocalStorage _storage = LocalStorage();
      _storage.removeActiveShop();
      navigateTo('/shop');
      return false;
    }
  }
}
