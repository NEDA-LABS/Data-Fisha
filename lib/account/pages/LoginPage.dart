import 'package:flutter/material.dart';
import 'package:smartstock/account/components/LoginForm.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/core/helpers/util.dart';

class LoginPage extends PageBase {
  final OnGeAppMenu onGetModulesMenu;
  final OnGetInitialPage onGetInitialModule;

  const LoginPage({
    Key? key,
    required this.onGetModulesMenu,
    required this.onGetInitialModule,
  }) : super(key: key, pageName: 'LoginPage');

  @override
  State<StatefulWidget> createState()=> _State();
}

class _State extends State<LoginPage>{
  @override
  Widget build(var context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: LoginForm(
            onGetModulesMenu: widget.onGetModulesMenu,
            onGetInitialModule: widget.onGetInitialModule,
          ),
        ),
      ),
    );
  }
}