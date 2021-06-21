import 'package:bfastui/adapters/page.adapter.dart';
import 'package:bfastui/bfastui.dart';
import 'package:flutter/material.dart';

import '../components/login.component.dart';

class LoginPage extends PageAdapter {
  @override
  Widget build(var args) {
    return Scaffold(
      body: BFastUI.component().custom(
        (context) => Container(
          color: Theme.of(context).primaryColor,
          child: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                //Image.asset("assets/logo.png"),
                LoginComponents().loginForm,
                LoginComponents().resetPassword,
                LoginComponents().company,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
