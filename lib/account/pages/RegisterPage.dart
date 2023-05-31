import 'package:flutter/material.dart';
import 'package:smartstock/account/components/RegisterForm.dart';
import 'package:smartstock/account/pages/LoginPage.dart';
import 'package:smartstock/core/services/util.dart';

class RegisterPage extends StatelessWidget {
  final OnGetModulesMenu onGetModulesMenu;

  const RegisterPage({Key? key, required this.onGetModulesMenu})
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
                builder: (context) =>
                    LoginPage(onGetModulesMenu: onGetModulesMenu),
              ),
              (route) => false,
            );
          },
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: RegisterForm(onGetModulesMenu: onGetModulesMenu),
        ),
      ),
    );
  }
}
