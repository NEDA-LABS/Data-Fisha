import 'package:flutter/material.dart';
import 'package:smartstock/account/components/LoginForm.dart';

class LoginPage extends StatelessWidget {
  final Function() onDoneSelectShop;

  const LoginPage({Key? key, required this.onDoneSelectShop}) : super(key: key);

  @override
  Widget build(var context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: LoginForm(onDoneSelectShop: onDoneSelectShop),
        ),
      ),
    );
  }
}
