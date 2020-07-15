import 'dart:convert';

import 'package:bfast/bfast.dart';
import 'package:bfastui/adapters/state.dart';
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
      } else {
        throw "User is null";
      }
    } catch (e) {
      print(e['message']);
      if (e != null && e['message']) {
        var message = jsonDecode(e['message']);
        print(message);
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
