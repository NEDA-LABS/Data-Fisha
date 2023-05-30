import 'package:flutter/material.dart';
import 'package:smartstock/account/components/RegisterForm.dart';
import 'package:smartstock/account/pages/LoginPage.dart';

class RegisterPage extends StatelessWidget {
  final Function(Map user) onDoneSelectShop;

  const RegisterPage({Key? key, required this.onDoneSelectShop})
      : super(key: key);

  @override
  Widget build(var context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Open account'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => LoginPage(
                  onDoneSelectShop: onDoneSelectShop,
                ),
              ),
              (route) => false,
            );
          },
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: RegisterForm(onDoneSelectShop: onDoneSelectShop),
        ),
      ),
    );
  }
}
