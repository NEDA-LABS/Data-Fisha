import 'package:flutter/material.dart';

Function() onAppGoBack(BuildContext context) {
  return (){
    var nav = Navigator.of(context);
    if (nav.canPop()) {
      nav.pop();
    } else {
      nav.pushNamedAndRemoveUntil('/', (route) => false);
    }
  };
}
