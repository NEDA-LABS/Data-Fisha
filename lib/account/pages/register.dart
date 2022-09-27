import 'package:flutter/material.dart';
import 'package:smartstock/account/components/register_form.dart';
import 'package:smartstock/core/services/util.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(var context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Open account'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              navigateToAndReplace('/account/login');
            },
          )),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(child: registerForm()),
      ),
    );
  }
}
