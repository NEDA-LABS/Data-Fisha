import 'package:flutter/material.dart';
import 'package:smartstock/account/components/LoginForm.dart';
import 'package:smartstock/core/services/util.dart';

class LoginPage extends StatelessWidget {
  final OnGetModulesMenu onGetModulesMenu;
  final OnGetInitialPage onGetInitialModule;

  const LoginPage({
    Key? key,
    required this.onGetModulesMenu,
    required this.onGetInitialModule,
  }) : super(key: key);

  @override
  Widget build(var context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: LoginForm(
            onGetModulesMenu: onGetModulesMenu,
            onGetInitialModule: onGetInitialModule,
          ),
        ),
      ),
    );
  }
}
