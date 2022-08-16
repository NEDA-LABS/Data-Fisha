import 'package:flutter/material.dart';
import '../../sales/services/stocks.service.dart';
import '../../common/services/util.dart';

class LoginPageState extends ChangeNotifier {
  String username = '';
  String password = '';
  bool onLoginProgress = false;
  bool showPassword = false;

  void toggleShowPassword() {
    this.showPassword = !this.showPassword;
    notifyListeners();
  }

  Future login({String username, String password}) async {
    try {
      onLoginProgress = true;
      notifyListeners();
      var user = await BFast.auth().logIn(username.trim(), password.trim());
      await BFast.auth().setCurrentUser(user);
      if (user != null) {
        username = user['username'];
        navigateToAndReplace('/shop');
      } else {
        throw "User is null";
      }
    } catch (e) {
      print(e);
      throw 'Fails to login';
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
      LocalStorage _storage = LocalStorage();
      _storage.removeActiveShop();
    });
    navigateTo('/login');
  }

  Future resetPassword(username) async {}
}
