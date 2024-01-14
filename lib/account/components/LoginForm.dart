import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartstock/account/pages/ChooseShopPage.dart';
import 'package:smartstock/account/pages/RegisterPage.dart';
import 'package:smartstock/account/states/shops.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/smartstock.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/TextInput.dart';
import 'package:smartstock/core/services/account.dart';
import 'package:smartstock/core/helpers/util.dart';

class LoginForm extends StatefulWidget {
  final OnGeAppMenu onGetModulesMenu;
  final OnGetInitialPage onGetInitialModule;

  const LoginForm({
    super.key,
    required this.onGetModulesMenu,
    required this.onGetInitialModule,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<LoginForm> {
  Map states = {
    'loading': false,
    'reset_loading': false,
    'username': '',
    'password': '',
    'show': false,
    'e_u': '',
    'e_p': ''
  };

  _prepareUpdateState() => ifDoElse(
      (x) => x is Map, (x) => setState(() => states.addAll(x)), (x) => null);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Container(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _iconContainer('icon-192.svg'),
              _usernameInput(states, _prepareUpdateState()),
              _passwordInput(states, _prepareUpdateState()),
              _loginButton(states, _prepareUpdateState(), context),
              _resetAccount(context, states, _prepareUpdateState()),
              _orSeparatorView(),
              _registerButton(states, _prepareUpdateState(), context)
            ],
          ),
        ),
      ),
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
          builder: (context) => AlertDialog(
            title: const Text("Info"),
            content: Text('$value'),
          ),
        );
      }).catchError((error) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
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
    accountLogin(username, password).then((value) {
      return getUserShops();
    }).then((value) async {
      var l = itOrEmptyArray(value).length;
      if (l == 1) {
        return await ChooseShopState().setCurrentShop(value[0]);
      } else {
        return -11;
      }
    }).then((value) {
      if (value == -11) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => ChooseShopPage(
              onGetModulesMenu: widget.onGetModulesMenu,
              onGetInitialModule: widget.onGetInitialModule,
            ),
          ),
          (route) => false,
        );
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => SmartStock(
              onGetModulesMenu: widget.onGetModulesMenu,
              onGetInitialPage: widget.onGetInitialModule,
            ),
          ),
          (route) => false,
        );
      }
    }).catchError((error) {
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
      onText: (x) => updateState(
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
      onText: (x) => updateState(
          {'username': x, 'e_u': x.isNotEmpty ? '' : 'Username required'}),
      error: states['e_u'] ?? '',
    );
  }

  _orSeparatorView() {
    Widget line = const Expanded(flex: 1, child: HorizontalLine());
    Widget orText = const Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Text(
        'OR',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          // color: Colors.black,
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [line, orText, line]),
    );
  }

  Widget _loginButton(states, updateState, context) => Container(
        child: states['loading'] == true
            ? Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8),
                child: const CircularProgressIndicator())
            : Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                height: 48,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(48)
                ),
                child: TextButton(
                  onPressed: () => _loginPressed(states, updateState, context),
                  // style: ButtonStyle(
                  //   backgroundColor: MaterialStateProperty.all(
                  //       Theme.of(context).colorScheme.tertiary),
                  //   overlayColor: MaterialStateProperty.resolveWith(
                  //     (states) {
                  //       return states.contains(MaterialState.pressed)
                  //           ? Theme.of(context).colorScheme.onTertiaryContainer
                  //           : null;
                  //     },
                  //   ),
                  // ),
                  child: BodyLarge(
                    text: "Login",
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
      );

  Widget _registerButton(states, updateState, context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      height: 48,
      width: MediaQuery.of(context).size.width,
      child: TextButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RegisterPage(
              onGetModulesMenu: widget.onGetModulesMenu,
              onGetInitialModule: widget.onGetInitialModule,
            ),
          ),
        ),
        child: const Text(
          "Open account for free.",
          style: TextStyle(
            // color: Theme.of(context).primaryColorDark,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  _iconContainer(String? svg) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
        child: Builder(
          builder: (context) => SizedBox(
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
              style: const TextStyle(
                fontWeight: FontWeight.w200,
                fontSize: 14,
                // color: Theme.of(context).primaryColorDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
