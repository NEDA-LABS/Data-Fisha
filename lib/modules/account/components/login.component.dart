import 'package:bfastui/bfastui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:smartstock/modules/account/states/login.state.dart';

class LoginComponents {
  final GlobalKey<FormBuilderState> _loginFormState =
  new GlobalKey<FormBuilderState>();

  Widget get company {
    return Center(
      child: InkWell(
        child: Text(
          "SmartStock @ 2020",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        onTap: () {},
      ),
    );
  }

  Widget get resetPassword {
    return BFastUI.component().consumer<LoginPageState>(
          (context, state) =>
          Container(
            padding: EdgeInsets.all(16),
            child: Center(
              child: InkWell(
                child: Text("Reset Password",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.white)),
                onTap: () {
                  if (state.username != null &&
                      state.username
                          .toString()
                          .isNotEmpty) {
                    state.resetPassword(state.username);
                  } else {
                    Scaffold.of(context).showSnackBar(SnackBar(
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
    return BFastUI.component().consumer<LoginPageState>((context, state) {
      return FormBuilderTextField(
        attribute: 'username',
        onChanged: (value) {
          state.username = value;
        },
        validators: [
          FormBuilderValidators.required(),
          FormBuilderValidators.minLength(1)
        ],
        cursorColor: Colors.black45,
        style: TextStyle(color: Colors.black45),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          focusedBorder: OutlineInputBorder(
            borderSide:
            BorderSide(color: Theme
                .of(context)
                .primaryColor, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
            BorderSide(color: Theme
                .of(context)
                .buttonColor, width: 2.0),
          ),
          filled: false,
          fillColor: Colors.black45,
          hintText: 'Username',
          hintStyle: TextStyle(color: Colors.black),
          prefixIcon: Icon(
            Icons.person,
            color: Theme
                .of(context)
                .primaryColor,
          ),
        ),
        obscureText: false,
      );
    });
  }

  Widget get _passwordFormControl {
    return BFastUI.component().consumer<LoginPageState>((context, state) {
      return FormBuilderTextField(
        attribute: 'password',
        maxLines: 1,
        cursorColor: Colors.black45,
        style: TextStyle(color: Colors.black45),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          focusedBorder: OutlineInputBorder(
            borderSide:
            BorderSide(color: Theme
                .of(context)
                .primaryColor, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
            BorderSide(color: Theme
                .of(context)
                .buttonColor, width: 2.0),
          ),
          filled: false,
          fillColor: Colors.black45,
          hintText: 'Password',
          hintStyle: TextStyle(color: Theme
              .of(context)
              .primaryColor),
          suffixIcon: state.showPassword
              ? IconButton(
            onPressed: () => state.toggleShowPassword(),
            icon: Icon(
              Icons.visibility,
              color: Theme
                  .of(context)
                  .primaryColor,
            ),
          )
              : IconButton(
            onPressed: () => state.toggleShowPassword(),
            icon: Icon(
              Icons.visibility_off,
              color: Theme
                  .of(context)
                  .primaryColor,
            ),
          ),
          prefixIcon: Icon(
            Icons.lock_outline,
            color: Theme
                .of(context)
                .primaryColor,
          ),

          //labelText: 'Title',
        ),
        obscureText: !state.showPassword,
        validators: [
          FormBuilderValidators.required(),
          FormBuilderValidators.minLength(1)
        ],
      );
    });
  }

  Widget get _loginButtons {
    return BFastUI.component().consumer<LoginPageState>((context, state) {
      return Container(
        child: state.onLoginProgress
            ? Container(
          child: CircularProgressIndicator(),
          alignment: Alignment.center,
          padding: EdgeInsets.all(8),
        )
            : Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ButtonTheme(
                minWidth: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: 50,
                child: RaisedButton(
                  color: Theme
                      .of(context)
                      .primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0)),
                  child: Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  onPressed: () {
                    if (_loginFormState.currentState.saveAndValidate() ==
                        true) {
                      state.login(
                          username: _loginFormState
                              .currentState.value['username'],
                          password: _loginFormState
                              .currentState.value['password']).catchError((e) {
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString()),));
                      });
                    } else {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("Fix all errors then submit again"),
                      ));
                    }
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
//            Container(
//              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
//              child: ButtonTheme(
//                minWidth: MediaQuery
//                    .of(context)
//                    .size
//                    .width,
//                height: 50,
//                child: RaisedButton(
//                    color: Theme
//                        .of(context)
//                        .primaryColor,
//                    shape: RoundedRectangleBorder(
//                        borderRadius: BorderRadius.circular(0.0)),
//                    child: Text(
//                      "Open Account For Free",
//                      style: TextStyle(
//                          color: Colors.white,
//                          fontWeight: FontWeight.bold,
//                          fontSize: 20),
//                    ),
//                    onPressed: () {
//                      BFastUI.navigation(moduleName: 'account').to('/account/register');
//                    }),
//              ),
//            ),
//            SizedBox(
//              height: 10,
//            ),
          ],
        ),
      );
    });
  }

  Widget get loginForm {
    return BFastUI.component().custom((context) =>
        FormBuilder(
          key: _loginFormState,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 180.0, bottom: 10.0),
                  child: Center(
                    child: Text("Login",
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ),
                Card(
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        // inputs
                        Container(
                            margin: EdgeInsets.only(
                              bottom: 10,
                              left: 10,
                              right: 10,
                            ),
                            child: this._userNameFormControl),
                        Container(
                          margin:
                          EdgeInsets.only(bottom: 10, left: 10, right: 10),
                          child: this._passwordFormControl,
                        ),
                        this._loginButtons
                        // buttons
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
