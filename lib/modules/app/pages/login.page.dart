import 'package:bfastui/adapters/page.dart';
import 'package:flutter/material.dart';

import '../components/login.component.dart';

class LoginPage extends PageAdapter {
  @override
  Widget build(var args) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          return Container(
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
          );
        }
      ),
    );
  }
}
