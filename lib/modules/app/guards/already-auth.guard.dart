import 'package:bfast/bfast.dart';
import 'package:bfastui/adapters/router-guard.adapter.dart';
import 'package:bfastui/bfastui.dart';
import 'package:smartstock_pos/modules/sales/services/stocks.service.dart';
import 'package:smartstock_pos/shared/local-storage.utils.dart';

class AlreadyAuthGuard extends RouterGuardAdapter {
  @override
  Future<bool> canActivate(String url) async {
    // BFast.auth().authenticated().then((value) {
    //   BFast.auth().setCurrentUser(value?.data);
    // }).catchError((onError) {
    //   BFast.auth().setCurrentUser(null);
    // });
    var user = await BFast.auth().currentUser();
    if (user == null) {
      return true;
    } else {
      StockSyncService.stop();
      SmartStockPosLocalStorage _storage = SmartStockPosLocalStorage();
      _storage.removeActiveShop();
      BFastUI.navigation(moduleName: 'account').to('/shop');
      return false;
    }
  }
}
