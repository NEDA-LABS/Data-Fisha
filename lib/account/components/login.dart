import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:smartstock_pos/core/services/util.dart';

import '../states/login.dart';

class LoginComponents {
  final GlobalKey<FormBuilderState> _loginFormState =
      GlobalKey<FormBuilderState>();

  // Widget get company {
  //   return Center(
  //     child: InkWell(
  //       child: const Text(
  //         "SmartStock @ 2022",
  //         style: TextStyle(
  //             fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
  //       ),
  //       onTap: () {},
  //     ),
  //   );
  // }

  Widget get resetPassword {
    return consumerComponent<LoginPageState>(
      builder: (context, state) => Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: InkWell(
            child: const Text(
              "Reset Password",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                // color: Colors.white
              ),
            ),
            onTap: () {
              if (state.username != null &&
                  state.username.toString().isNotEmpty) {
                state.resetPassword(state.username);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Enter your username to reset password"),
                ));
              }
            },
          ),
        ),
      ),
    );
  }

  Widget get _userNameFormControl {
    return consumerComponent<LoginPageState>(builder: (context, state) {
      return FormBuilderTextField(
        name: 'username',
        maxLines: 1,
        onChanged: (value) {
          state.username = value ?? '';
        },
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
          FormBuilderValidators.minLength(1)
        ]),
        cursorColor: Colors.black45,
        style: const TextStyle(color: Colors.black45),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).buttonColor, width: 2.0),
          ),
          filled: false,
          fillColor: Colors.black45,
          hintText: 'Username',
          hintStyle: const TextStyle(color: Colors.black),
          prefixIcon: Icon(
            Icons.person,
            color: Theme.of(context).primaryColor,
          ),
        ),
        obscureText: false,
      );
    });
  }

  Widget get _passwordFormControl {
    return consumerComponent<LoginPageState>(builder: (context, state) {
      return FormBuilderTextField(
        name: 'password',
        maxLines: 1,
        cursorColor: Colors.black45,
        style: const TextStyle(color: Colors.black45),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).buttonColor, width: 2.0),
          ),
          filled: false,
          fillColor: Colors.black45,
          hintText: 'Password',
          hintStyle: TextStyle(color: Theme.of(context).primaryColor),
          suffixIcon: state.showPassword
              ? IconButton(
                  onPressed: () => state.toggleShowPassword(),
                  icon: Icon(
                    Icons.visibility,
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : IconButton(
                  onPressed: () => state.toggleShowPassword(),
                  icon: Icon(
                    Icons.visibility_off,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
          prefixIcon: Icon(
            Icons.lock_outline,
            color: Theme.of(context).primaryColor,
          ),

          //labelText: 'Title',
        ),
        obscureText: !state.showPassword,
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
          FormBuilderValidators.minLength(1)
        ]),
      );
    });
  }

  Widget get _loginButtons {
    return consumerComponent<LoginPageState>(builder: (context, state) {
      return Container(
        child: state.onLoginProgress
            ? Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8),
                child: const CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width,
                      height: 50,
                      child: FlatButton(
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0)),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        onPressed: () {
                          if (_loginFormState.currentState?.saveAndValidate() ==
                              true) {
                            state
                                .login(
                                    username: _loginFormState
                                        .currentState?.value['username'],
                                    password: _loginFormState
                                        .currentState?.value['password'])
                                .catchError((e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('$e'),
                              ));
                            });
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Fix all errors then submit again"),
                            ));
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
      );
    });
  }

  Widget get loginForm {
    return Builder(
      builder: (context) => FormBuilder(
        key: _loginFormState,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Card(
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  // inputs
                  Container(
                      margin: const EdgeInsets.only(
                        bottom: 10,
                        left: 10,
                        right: 10,
                      ),
                      child: _userNameFormControl),
                  Container(
                    margin:
                        const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                    child: _passwordFormControl,
                  ),
                  _loginButtons
                  // buttons
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
