import 'package:flutter/material.dart';

import '../components/login.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(var args) {
    return Scaffold(
      body: Builder(builder: (context) {
        return Container(
          // color: Theme.of(context).primaryColor,
          height: MediaQuery.of(context).size.height,
          child: Center(
            // alignment: Alignment.center,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 390),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  //Image.asset("assets/logo.png"),
                  LoginComponents().loginForm,
                  LoginComponents().resetPassword,
                  // LoginComponents().company,
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
