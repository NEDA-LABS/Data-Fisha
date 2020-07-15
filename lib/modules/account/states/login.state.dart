import 'package:bfast/bfast.dart';
import 'package:bfastui/adapters/state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginPageState extends BFastUIState {
  String username;
  String password;
  bool onLoginProgress = false;

  login({@required String username, @required String password}) {
    print('login button *******');
    BFast.auth().currentUser().then((value){
      print(value['username']);
      print("*********login button");
    });
    onLoginProgress = true;
    BFast.auth().logIn(username, password).then((value) {
      print(value);
    }).catchError((e) {
      print("errors to login");
      print(e.toString());
    }).whenComplete(() {
      onLoginProgress = false;
      notifyListeners();
    });
    notifyListeners();
  }
}
