import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/text_input.dart';
import 'package:smartstock/core/services/account.dart';
import 'package:smartstock/core/services/util.dart';

Widget _loginButton(states, updateState, context) =>
    Container(
        child: states['loading'] == true
            ? Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            child: const CircularProgressIndicator())
            : Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            height: 48,
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: ElevatedButton(
                onPressed: () => _loginPressed(states, updateState, context),
                child: const Text("Login",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18)))));

Widget _registerButton(states, updateState, context) {
  return Container(
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
    height: 48,
    width: MediaQuery
        .of(context)
        .size
        .width,
    child: OutlinedButton(
      onPressed: () => navigateTo('/account/register'),
      child: Text(
        "Open account for free.",
        style: TextStyle(
            color: Theme
                .of(context)
                .primaryColorDark,
            fontWeight: FontWeight.w500,
            fontSize: 16),
      ),
    ),
  );
}

_iconContainer(String? svg) =>
    Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
      child: Builder(
        builder: (context) =>
            SizedBox(
              width: 70,
              height: 70,
              child: SvgPicture.asset(
                'assets/svg/$svg',
                width: 24,
                fit: BoxFit.scaleDown,
              ),
            ),
      ),
    );

_resetAccount(context, states, updateState) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: Row(
      children: [
        Expanded(flex: 2, child: Container()),
        InkWell(
          onTap: states['reset_loading'] == true
              ? null
              : _resetTapped(context, states, updateState),
          child: Text(
            states['reset_loading'] == true
                ? 'Waiting...'
                : 'Reset account password.',
            textAlign: TextAlign.end,
            style: TextStyle(
                fontWeight: FontWeight.w200,
                fontSize: 14,
                color: Theme
                    .of(context)
                    .primaryColorDark),
          ),
        ),
      ],
    ),
  );
}

Widget loginForm() {
  Map states = {
    'loading': false,
    'reset_loading': false,
    'username': '',
    'password': '',
    'show': false,
    'e_u': '',
    'e_p': ''
  };
  return StatefulBuilder(
    builder: (context, setState) {
      var updateState = ifDoElse((x) => x is Map, (x) =>
          setState(() => states.addAll(x)), (x) => null);
      return SizedBox(
        height: MediaQuery
            .of(context)
            .size
            .height,
        child: Center(
          child: Container(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _iconContainer('icon-192.svg'),
                _usernameInput(states, updateState),
                _passwordInput(states, updateState),
                _loginButton(states, updateState, context),
                _resetAccount(context, states, updateState),
                _orSeparatorView(),
                _registerButton(states, updateState, context)
              ],
            ),
          ),
        ),
      );
    },
  );
}

_resetTapped(context, states, updateState) {
  var username = states['username'];
  return () {
    if ((username is String && username.isEmpty) || username == null) {
      updateState({'e_u': 'Username required to reset your account.'});
      return;
    }
    updateState({'e_u': '', 'reset_loading': true});
    accountResetPassword(username).then((value) {
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: const Text("Info"),
              content: Text('$value'),
            ),
      );
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: const Text("Error"),
              content: Text('$error'),
            ),
      );
    }).whenComplete(() {
      updateState({'reset_loading': false});
    });
  };
}

_loginPressed(states, updateState, context) {
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

_passwordInput(states, updateState) {
  return TextInput(
    label: "Password",
    initialText: states['password'],
    onText: (x) =>
        updateState(
            {'password': x, 'e_p': x.isNotEmpty ? '' : 'Password required'}),
    error: states['e_p'] ?? '',
    show: states['show'] == true,
    icon: IconButton(
      onPressed: () {
        updateState({'show': !states['show']});
      },
      icon: Icon(
          states['show'] == true ? Icons.visibility : Icons.visibility_off),
    ),
  );
}

_usernameInput(states, updateState) {
  return TextInput(
    label: "Username",
    initialText: states['username'],
    onText: (x) =>
        updateState(
            {'username': x, 'e_u': x.isNotEmpty ? '' : 'Username required'}),
    error: states['e_u'] ?? '',
  );
}

_orSeparatorView() {
  Widget line = Expanded(flex: 1, child: horizontalLine());
  Widget orText = const Padding(
    padding: EdgeInsets.symmetric(horizontal: 5),
    child: Text(
      'OR',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: Colors.black,
      ),
    ),
  );
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(children: [line, orText, line]),
  );
}
