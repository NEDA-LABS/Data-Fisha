import 'package:flutter/material.dart';
import 'package:smartstock/account/components/RegisterForm.dart';
import 'package:smartstock/account/pages/LoginPage.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/core/services/util.dart';

class RegisterPage extends PageBase {
  final OnGetModulesMenu onGetModulesMenu;
  final OnGetInitialPage onGetInitialModule;

  const RegisterPage({
    Key? key,
    required this.onGetModulesMenu,
    required this.onGetInitialModule,
  }) : super(key: key, pageName: 'RegisterPage');

  @override
  State<StatefulWidget> createState()=> _State();

}

class _State extends State<RegisterPage>{
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
                  onGetModulesMenu: widget.onGetModulesMenu,
                  onGetInitialModule: widget.onGetInitialModule,
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
          child: RegisterForm(
            onGetModulesMenu: widget.onGetModulesMenu,
            onGetInitialModule: widget.onGetInitialModule,
          ),
        ),
      ),
    );
  }
}
