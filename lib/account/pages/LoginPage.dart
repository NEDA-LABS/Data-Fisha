import 'package:flutter/material.dart';
import 'package:smartstock/account/components/LoginForm.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(var context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: const SingleChildScrollView(child: LoginForm()),
      ),
    );
  }
}
