import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartstock/account/services/register.dart';
import 'package:smartstock/core/components/active_component.dart';
import 'package:smartstock/core/components/choices_input.dart';
import 'package:smartstock/core/components/mobile_input.dart';
import 'package:smartstock/core/components/text_input.dart';
import 'package:smartstock/core/services/account.dart';
import 'package:smartstock/core/services/util.dart';

final _formInitialState = {
  'loading': false,
  'username': '',
  'password': '',
  'businessName': '',
  'fullname': '',
  'email': '',
  'country': '',
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

Widget _registerButton(states, updateState, context) {
  return Container(
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
              onPressed: () => _registerPressed(states, updateState, context),
              child: const Text(
                "Register",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
          ),
  );
}

_goToLogin(context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: Row(
      children: [
        Expanded(flex: 2, child: Container()),
        InkWell(
          onTap: () => navigateToAndReplace('/account/login'),
          child: Text(
            'Already have account? Go to login.',
            textAlign: TextAlign.end,
            style: TextStyle(
                fontWeight: FontWeight.w200,
                fontSize: 14,
                color: Theme.of(context).primaryColorDark),
          ),
        ),
      ],
    ),
  );
}

Widget registerForm() {
  return ActiveComponent(
    initialState: _formInitialState,
    builder: (context, states, updateState) {
      return Align(
        alignment: Alignment.topCenter,
        child: Container(
          padding: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _businessInput(states, updateState),
              _fullnameInput(states, updateState),
              _emailInput(states, updateState),
              _countryInput(states, updateState),
              _mobileInput(states, updateState),
              _separatorView(),
              _usernameInput(states, updateState),
              _passwordInput(states, updateState),
              _registerButton(states, updateState, context),
              _goToLogin(context),
            ],
          ),
        ),
      );
    },
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
    err['e_password'] = 'Password required';
  }
  if ((businessName is String && businessName.isEmpty) ||
      businessName is! String) {
    err['e_business'] = 'Business name required';
  }
  if ((businessName is String && businessName.isEmpty) ||
      businessName is! String) {
    err['e_business'] = 'Business name required';
  }
  if ((fullname is String && fullname.isEmpty) || businessName is! String) {
    err['e_fullname'] = 'Fullname required';
  }
  if ((email is String && email.isEmpty) || email is! String) {
    err['e_email'] = 'Email required';
  }
  if ((country is String && country.isEmpty) || country is! String) {
    err['e_country'] = 'Country required';
  }
  if ((mobile is String && mobile.isEmpty) || mobile is! String) {
    err['e_mobile'] = 'Mobile required';
  }
  updateState(err);
  return err.isNotEmpty;
}

_registerPressed(states, updateState, context) {
  var isValid = _isFormValid(states, updateState);
  if(isValid == true){
    // updateState({'loading': true});
    // accountLogin(username, password)
    //     .then((value) => navigateToAndReplace('/shop'))
    //     .catchError((error) {
    //   showDialog(
    //       context: context,
    //       builder: (context) =>
    //           AlertDialog(title: const Text('Error'), content: Text('$error')));
    // }).whenComplete(() => updateState({'loading': false}));
  }
}

_passwordInput(states, updateState) {
  return TextInput(
    label: "Password",
    initialText: states['password'],
    onText: (x) => updateState(
        {'password': x, 'e_p': x.isNotEmpty ? '' : 'Password required'}),
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
    onText: (x) => updateState(
        {'username': x, 'e_username': x.isNotEmpty ? '' : 'Username required'}),
    error: states['e_username'] ?? '',
  );
}

_fullnameInput(states, updateState) {
  return TextInput(
    label: "Your fullname",
    initialText: states['fullname'],
    onText: (x) => updateState(
        {'fullname': x, 'e_fullname': x.isNotEmpty ? '' : 'Username required'}),
    error: states['e_fullname'] ?? '',
  );
}

_businessInput(states, updateState) {
  return TextInput(
    label: "Business name",
    initialText: states['businessName'],
    onText: (x) => updateState({
      'businessName': x,
      'e_business': x.isNotEmpty ? '' : 'Business name required'
    }),
    error: states['e_business'] ?? '',
  );
}

_emailInput(states, updateState) {
  return TextInput(
    label: "Email",
    initialText: states['email'],
    onText: (x) => updateState(
        {'email': x, 'e_mail': x.isNotEmpty ? '' : 'Email required'}),
    error: states['e_email'] ?? '',
  );
}

_mobileInput(states, updateState) {
  return MobileInput(
    initialText: states['mobile'],
    onText: (x) => updateState(
        {'mobile': x, 'e_mobile': x.isNotEmpty ? '' : 'Email required'}),
    error: states['e_mobile'] ?? '',
  );
}

_countryInput(states, updateState) {
  return ChoicesInput(
    label: "Country",
    initialText: states['country'],
    onText: (x) => updateState(
        {'country': x, 'e_country': x.isNotEmpty ? '' : 'Country required'}),
    error: states['e_country'] ?? '',
    onLoad: ({skipLocal = false}) async => getCountries(),
    placeholder: "Choose country",
    onField: (a) {
      return '${a['name']} - ${a['code']}';
    },
  );
}

_separatorView() {
  Widget line = const Expanded(flex: 1, child: Divider());
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 24),
    child: Row(children: [line]),
  );
}
