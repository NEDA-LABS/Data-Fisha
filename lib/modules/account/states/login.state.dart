import 'dart:convert';

import 'package:bfast/bfast.dart';
import 'package:bfastui/adapters/state.dart';
import 'package:bfastui/bfastui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginPageState extends BFastUIState {
  String username;
  String password;
  bool onLoginProgress = false;
  bool showPassword = false;

  void toggleShowPassword() {
    this.showPassword = !this.showPassword;
    notifyListeners();
  }

  Future login({@required String username, @required String password}) async {
    try {
      onLoginProgress = true;
      notifyListeners();
      var user = await BFast.auth().logIn(username, password);
      if (user != null) {
        BFastUI.navigation(moduleName: 'account').to('/dashboard');
      } else {
        throw "User is null";
      }
    } catch (e) {
      if (e != null && e['message']!=null) {
        var message = jsonDecode(e['message']) as Map<String,dynamic>;
        throw message['error'];
      } else {
        throw 'Fails to login';
      }
    } finally {
      onLoginProgress = false;
      notifyListeners();
    }
  }

  Future resetPassword(username) async {}
}
