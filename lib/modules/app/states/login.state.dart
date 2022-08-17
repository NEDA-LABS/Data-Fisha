import 'dart:convert';

import 'package:bfast/bfast.dart';
import 'package:flutter/material.dart';
import 'package:smartstock_pos/modules/sales/services/stocks.service.dart';
import 'package:smartstock_pos/modules/shared/local-storage.utils.dart';
import 'package:smartstock_pos/util.dart';

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
    navigateTo('/login');
  }

  Future resetPassword(username) async {}
}
