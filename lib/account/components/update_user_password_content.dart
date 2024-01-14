import 'package:flutter/material.dart';
import 'package:smartstock/core/components/TextInput.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/stocks/services/api_product.dart';

import '../services/shop_users.dart';

class UpdateUserPasswordContent extends StatefulWidget {
  final String? userId;
  final String? password;

  const UpdateUserPasswordContent(
      {required this.userId, required this.password, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<UpdateUserPasswordContent> {
  String password = '';
  String qErr = '';
  String reqErr = '';
  bool progress = false;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: ListBody(children: [
            TextInput(
                onText: (d) {
                  setState(() {
                    password = d;
                    qErr = '';
                  });
                },
                initialText: '',
                label: "Password",
                error: qErr),
            Container(
              height: 64,
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: OutlinedButton(
                        onPressed: progress ? null : _offsetQuantity,
                        child: Text(
                          progress ? "Waiting..." : "Confirm",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Text(reqErr, style: const TextStyle(color: Colors.red),)
          ]),
        ),
      );

  _offsetQuantity() {
    if (!(password is String && password.isNotEmpty)) {
      setState(() {
        qErr = 'required';
      });
      return;
    }
    setState(() {
      qErr = '';
      reqErr = '';
      progress = true;
    });
    updateUserPassword(widget.userId, password).then((value) {
      // print(value);
      Navigator.of(context).maybePop();
    }).catchError((err) {
      // print(err);
      setState(() {
        // qErr = '$err';
        reqErr = '$err';
      });
    }).whenComplete(() {
      setState(() {
        // qErr = '';
        // reqErr = '';
        progress = false;
      });
    });
  }
}
