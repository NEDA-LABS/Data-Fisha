import 'package:bfastui/adapters/page.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/modules/account/components/register.component.dart';

class RegisterPage extends BFastUIPage {
  @override
  Widget build(args) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        title: Text('Register'),
      ),
      body: Container(
        child: RegisterComponents().registerForm,
      ),
    );
  }
}
