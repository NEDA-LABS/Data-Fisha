import 'package:bfastui/bfastui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:smartstock/modules/account/states/login.state.dart';

class LoginComponents {
  final GlobalKey<FormBuilderState> _formKey =
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
    return Center(
      child: InkWell(
        child: Text("Reset Password",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        onTap: () {},
      ),
    );
  }

  Widget get _userNameFormControl {
    return BFastUI.component().custom((context) {
      return FormBuilderTextField(
        attribute: 'username',
//      validator:
//       validations.validateUserName,
        cursorColor: Colors.black45,
        style: TextStyle(color: Colors.black45),
//      focusNode: _emailNode,
//      controller: _usernameController,
        decoration: InputDecoration(
          hasFloatingPlaceholder: true,
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
          hintStyle: TextStyle(color: Colors.black),
          prefixIcon: Icon(
            Icons.person,
            color: Theme.of(context).primaryColor,
          ),

          //labelText: 'Title',
        ),
        obscureText: false,
//        onSaved: (String email) {},
      );
    });
  }

  Widget get _passwordFormControl {
    return BFastUI.component().custom((context) {
      return FormBuilderTextField(
        attribute: 'password',
        maxLines: 1,
        cursorColor: Colors.black45,
        style: TextStyle(color: Colors.black45),
//        focusNode: _passwordNode,
//        controller: _passwordController,
        decoration: InputDecoration(
          hasFloatingPlaceholder: true,
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
          prefixIcon: Icon(
            Icons.lock_outline,
            color: Theme.of(context).primaryColor,
          ),

          //labelText: 'Title',
        ),
        obscureText: true,
        // validator:
//        validations.validatePassword,
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
                      minWidth: MediaQuery.of(context).size.width,
                      height: 50,
                      child: RaisedButton(
                        color: Theme.of(context).primaryColor,
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
//                          _formKey.currentState.save();
                      state.login(
                          username: _formKey.currentState.value['username'],
                          password:  _formKey.currentState.value['password']);
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width,
                      height: 50,
                      child: RaisedButton(
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0)),
                          child: Text(
                            "Open Account For Free",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          onPressed: () {
                            // _handleSubmitted();
                          }),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
      );
    });
  }

  Widget get loginForm {
    return BFastUI.component().custom((context) => FormBuilder(
          key: _formKey,
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
