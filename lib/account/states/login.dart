import 'package:flutter/material.dart';
import 'package:smartstock_pos/core/services/cache_shop.dart';
import 'package:smartstock_pos/core/services/cache_user.dart';
import 'package:smartstock_pos/configurations.dart';
import '../../sales/services/stocks.dart';
import '../../core/services/util.dart';
import '../services/user.dart';

class LoginPageState extends ChangeNotifier {
  String username = '';
  String password = '';
  bool onLoginProgress = false;
  bool showPassword = false;

  void toggleShowPassword() {
    showPassword = !showPassword;
    notifyListeners();
  }

  Future login({String username, String password}) async {
    try {
      onLoginProgress = true;
      notifyListeners();
      var loginToSmartStock = remoteLogin(smartstockApp);
      var user = await loginToSmartStock(username.trim(), password.trim());
      await setLocalCurrentUser(user);
      if (user != null) {
        username = user['username'];
        navigateToAndReplace('/');
      } else {
        throw "User is null";
      }
    } finally {
      onLoginProgress = false;
      notifyListeners();
    }
  }

  logOut() {
    removeLocalCurrentUser().catchError((r) {
      // print(r);
    }).whenComplete(() {
      StockSyncService.stop();
      removeActiveShop();
    });
    navigateTo('/login');
  }

  Future resetPassword(username) async {}
}
