import 'package:flutter/material.dart';
import 'package:smartstock/core/components/active_component.dart';
import 'package:smartstock/core/components/text_input.dart';
import 'package:smartstock/core/services/account.dart';
import 'package:smartstock/core/services/util.dart';

Widget _loginButtons(states, updateState, context) => Container(
    child: states['loading'] == true
        ? Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            child: const CircularProgressIndicator())
        : Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            height: 48,
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
                onPressed: () => _login(states, updateState, context),
                child: const Text("Login",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18)))));

Widget loginForm() => ActiveComponent(
      initialState: const {
        'loading': false,
        'username': '',
        'password': '',
        'show': false,
        'e_u': '',
        'e_p': ''
      },
      builder: (context, states, updateState) => SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Center(
              child: Container(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    TextInput(
                      label: "Username",
                      initialText: states['username'],
                      onText: (x) => updateState({
                        'username': x,
                        'e_u': x.isNotEmpty ? '' : 'Username required'
                      }),
                      error: states['e_u'] ?? '',
                    ),
                    TextInput(
                        label: "Password",
                        initialText: states['password'],
                        onText: (x) => updateState({
                              'password': x,
                              'e_p': x.isNotEmpty ? '' : 'Password required'
                            }),
                        error: states['e_p'] ?? '',
                        show: states['show'] == true,
                        icon: IconButton(
                            onPressed: () {
                              updateState({'show': !states['show']});
                              print('visible clicked');
                            },
                            icon: Icon(states['show'] == true
                                ? Icons.visibility
                                : Icons.visibility_off))

                        // states['show'] == true
                        //     ? IconButton(
                        //         icon: const Icon(Icons.visibility),
                        //         onPressed: (){
                        //           updateState({'show': !states['show']});
                        //           print('visible clicked');
                        //         })
                        //     : IconButton(
                        //         onPressed: () => updateState({'show': false}),
                        //         icon: const Icon(Icons.visibility_off)),
                        ),
                    _loginButtons(states, updateState, context)
                  ])))),
    );

_login(states, updateState, context) {
  var username = states['username'];
  var password = states['password'];
  if ((username is String && username.isEmpty) || username is! String) {
    updateState({'e_u': 'Username required'});
    return;
  }
  if ((password is String && password.isEmpty) || password is! String) {
    updateState({'e_p': 'Password required'});
    return;
  }
  updateState({'loading': true});
  accountLogin(username, password)
      .then((value) => navigateToAndReplace('/shop'))
      .catchError((error) {
    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: const Text('Error'), content: Text('$error')));
  }).whenComplete(() => updateState({'loading': false}));
}
