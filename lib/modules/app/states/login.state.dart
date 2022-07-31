import 'package:bfast/bfast.dart';
import 'package:bfastui/adapters/state.adapter.dart';
import 'package:bfastui/bfastui.dart';
import 'package:smartstock_pos/modules/sales/services/stocks.service.dart';
import 'package:smartstock_pos/shared/local-storage.utils.dart';

class LoginPageState extends StateAdapter {
  String username = '';
  String password = '';
  bool onLoginProgress = false;
  bool showPassword = false;

  void toggleShowPassword() {
    this.showPassword = !this.showPassword;
    notifyListeners();
  }

  Future login({ String username, String password}) async {
    try {
      onLoginProgress = true;
      notifyListeners();
      var user = await BFast.auth().logIn(username.trim(), password.trim());
      await BFast.auth().setCurrentUser(user);
      if (user != null) {
        username = user['username'];
        BFastUI.navigateToAndReplace('/shop');
      } else {
        throw "User is null";
      }
    } catch (e) {
      print(e);
      // if (e != null && e['message'] != null) {
      //   var message = jsonDecode(e['message']) as Map<String, dynamic>;
      //   throw message['error'];
      // } else {
        throw 'Fails to login';
      // }
    } finally {
      onLoginProgress = false;
      notifyListeners();
    }
  }

  logOut() {
    BFast.auth().logOut().then((value) async {
      BFast.auth().setCurrentUser(null);
    }).catchError((r) {
      print(r);
    }).whenComplete(() {
      StockSyncService.stop();
      SmartStockPosLocalStorage _storage = SmartStockPosLocalStorage();
      _storage.removeActiveShop();
    });
    BFastUI.navigateTo('/login');
  }

  Future resetPassword(username) async {}
}
