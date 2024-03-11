import 'package:flutter/material.dart';
import 'package:smartstock/account/pages/ChooseShopPage.dart';
import 'package:smartstock/account/states/shops.dart';
import 'package:smartstock/chatafisha.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/TextInput.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/info_dialog.dart';
import 'package:smartstock/core/components/mobile_input.dart';
import 'package:smartstock/core/helpers/configs.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/services/account.dart';

class RegisterForm extends StatefulWidget {
  final OnGeAppMenu onGetModulesMenu;
  final OnGetInitialPage onGetInitialModule;

  const RegisterForm({
    super.key,
    required this.onGetModulesMenu,
    required this.onGetInitialModule,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<RegisterForm> {
  final Map _country = {"name": 'Tanzania, United Republic of', 'code': 'TZ'};
  Map states = {
    'loading': false,
    'username': '',
    'password': '',
    'businessName': '',
    'fullname': '',
    'email': '',
    'country': {"name": 'Tanzania, United Republic of', 'code': 'TZ'},
    'mobile': '',
    'show': false,
    'e_username': '',
    'e_password': '',
    'e_business': '',
    'e_fullname': '',
    'e_email': '',
    'e_country': '',
    'e_mobile': '',
  };

  _prepareUpdateState() => ifDoElse(
      (x) => x is Map, (x) => setState(() => states.addAll(x)), (x) => null);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _businessInput(states, _prepareUpdateState()),
        _fullnameInput(states, _prepareUpdateState()),
        _emailInput(states, _prepareUpdateState()),
        _countryInput(states, _prepareUpdateState()),
        _mobileInput(states, _prepareUpdateState()),
        _separatorView(),
        _usernameInput(states, _prepareUpdateState()),
        _passwordInput(states, _prepareUpdateState()),
        _registerButton(states, _prepareUpdateState(), context),
        // _goToLogin(context),
      ],
    );
  }

  bool _isFormValid(states, updateState) {
    var username = states['username'];
    var password = states['password'];
    var businessName = states['businessName'];
    var fullname = states['fullname'];
    var email = states['email'];
    var country = states['country'];
    var mobile = states['mobile'];
    var err = {};
    if ((username is String && username.isEmpty) || username is! String) {
      err['e_username'] = 'Username required';
    }
    if ((password is String && password.isEmpty) || password is! String) {
      err['e_password'] = 'Password must be at least 8 characters';
    }
    if ((businessName is String && businessName.isEmpty) ||
        businessName is! String) {
      err['e_business'] = 'Center name required';
    }
    if ((fullname is String && fullname.isEmpty) || businessName is! String) {
      err['e_fullname'] = 'Fullname required';
    }
    if ((email is String && email.isEmpty) || email is! String) {
      err['e_email'] = 'Email required';
    }
    if ((country is Map && country['name'].isEmpty) || country is! Map) {
      err['e_country'] = 'Country required';
    }
    if ((mobile is String && mobile.isEmpty) || mobile is! String) {
      err['e_mobile'] = 'Complete 9 remaining digit';
    }
    updateState(err);
    return err.keys.isEmpty;
  }

  _registerPressed(states, updateState, context) {
    var isValid = _isFormValid(states, updateState);
    if (isValid == true) {
      lE(error) {
        showTransactionCompleteDialog(context, '$error',
            title: 'Error', canDismiss: true
            // builder: (context) => AlertDialog(
            //     title: const BodyMedium(text: 'Error'), content: BodyLarge(text: '$error')
            );
      }

      var data = {
        "username": states['username'],
        'password': states['password'],
        'email': states['email'],
        'firstname': states['fullname'],
        'lastname': '.',
        'mobile': '255${states['mobile']}',
        'businessName': states['businessName'],
        'region': states['country']?['name'] ?? 'n/a',
        'country': states['country']?['name'] ?? 'n/a',
        'street': states['country']?['name'] ?? 'n/a',
        'vendor': {'name': getVendorName(), 'cost': getVendorCost()}
      };
      updateState({'loading': true});
      accountRegister(data)
          .then((value) => getUserShops())
          .then((value) async {
            var l = itOrEmptyArray(value).length;
            if (l == 1) {
              return await ChooseShopState().setCurrentShop(value[0]);
            } else {
              return -11;
            }
          })
          .then((value) {
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
          })
          // .then((value) {
          //   Navigator.of(context).pushAndRemoveUntil(
          //     MaterialPageRoute(
          //       builder: (context) =>
          //           ChooseShopPage(onGetModulesMenu: widget.onGetModulesMenu),
          //     ),
          //     (route) => false,
          //   );
          // })
          .catchError(lE)
          .whenComplete(() => updateState({'loading': false}));
    }
  }

  _passwordInput(states, updateState) {
    return TextInput(
      label: "Password",
      initialText: states['password'],
      onText: (x) => updateState({
        'password': x,
        'e_password': x.isNotEmpty && x.length >= 8
            ? ''
            : 'Password must be at least 8 characters'
      }),
      error: states['e_password'] ?? '',
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
      onText: (x) => updateState({
        'username': x,
        'e_username': x.isNotEmpty ? '' : 'Username required'
      }),
      error: states['e_username'] ?? '',
    );
  }

  _fullnameInput(states, updateState) {
    return TextInput(
      label: "Your fullname",
      initialText: states['fullname'],
      onText: (x) => updateState({
        'fullname': x,
        'e_fullname': x.isNotEmpty ? '' : 'Username required'
      }),
      error: states['e_fullname'] ?? '',
    );
  }

  _businessInput(states, updateState) {
    return TextInput(
      label: "Center name",
      initialText: states['businessName'],
      onText: (x) => updateState({
        'businessName': x,
        'e_business': x.isNotEmpty ? '' : 'Center name required'
      }),
      error: states['e_business'] ?? '',
    );
  }

  _emailInput(states, updateState) {
    return TextInput(
      label: "Email",
      initialText: states['email'],
      onText: (x) => updateState(
          {'email': x, 'e_email': x.isNotEmpty ? '' : 'Email required'}),
      error: states['e_email'] ?? '',
    );
  }

  _mobileInput(states, updateState) {
    return MobileInput(
      initialText: states['mobile'],
      onText: (x) => updateState({
        'mobile': x,
        'e_mobile':
            x.isNotEmpty && x.length >= 9 ? '' : 'Complete 9 remaining digit'
      }),
      error: states['e_mobile'] ?? '',
    );
  }

  _countryInput(states, updateState) {
    return TextInput(
      initialText: _country['name'],
      label: "Country",
      readOnly: true,
      onText: (x) {
        // _country = x;
        // updateState({
        //   'country': x,
        //   'e_country': x.isNotEmpty ? '' : 'Country required'
        // });
      },
      error: states['e_country'] ?? '',
      // onLoad: ([skipLocal = false]) async => getCountries(),
      placeholder: "Choose country",
      // onField: (a) {
      //   if (a is Map) {
      //     return '${a['name'] ?? ''} - ${a['code'] ?? ''}';
      //   }
      //   return '';
      // },
    );
  }

  _separatorView() {
    Widget line = const Expanded(flex: 1, child: HorizontalLine());
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(children: [line]),
    );
  }

  Widget _registerButton(states, updateState, context) {
    return Container(
      child: states['loading'] == true
          ? Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16),
              child: const CircularProgressIndicator())
          : Container(
              margin: const EdgeInsets.symmetric(vertical: 24),
              height: 48,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(48)),
              child: TextButton(
                onPressed: () => _registerPressed(states, updateState, context),
                child: BodyLarge(
                  text: "Register",
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
    );
  }

// _goToLogin(context) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 16),
//     child: Row(
//       children: [
//         Expanded(flex: 2, child: Container()),
//         InkWell(
//           onTap: () {
//             Navigator.of(context).pushAndRemoveUntil(
//               MaterialPageRoute(
//                 builder: (context) => LoginPage(
//                   onGetModulesMenu: widget.onGetModulesMenu,
//                   onGetInitialModule: widget.onGetInitialModule,
//                 ),
//               ),
//               (route) => false,
//             );
//           },
//           child: const BodySmall(text: 'Already have account? Go to login.'),
//         ),
//       ],
//     ),
//   );
// }
}
