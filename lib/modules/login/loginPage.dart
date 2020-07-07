import 'package:flutter/material.dart';
import 'package:smartstock_flutter_mobile/configurations.dart';
import 'package:smartstock_flutter_mobile/shared/validations.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final ScrollController scrollController = new ScrollController();
  bool autoValidate = false;
  Validations validations = new Validations();

  AnimationController animationControllerButton;

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _emailNode = FocusNode();
  final _passwordNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Config.primaryColor,
          ),
          Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.95,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                //Image.asset("assets/logo.png"),
                Form(
                    key: formKey,
                    autovalidate: autoValidate,
                    child: Padding(
                      padding: const EdgeInsets.only(left:16.0,right: 16.0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 180.0, bottom: 10.0),
                            child: Center(child: Text("Login",style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,color: Colors.white))),
                          ),
                          Card(child: Container(
                            margin: EdgeInsets.only(top:10),
                            child: Column(
                              children: [
                                Container(
                                  margin:
                                  EdgeInsets.only(bottom: 10, left: 10, right: 10),
                                  child: TextFormField(
                                    validator: validations.validateUserName,
                                    cursorColor: Colors.black45,
                                    style: TextStyle(color: Colors.black45),
                                    focusNode: _emailNode,
                                    controller: _usernameController,
                                    decoration: InputDecoration(
                                      hasFloatingPlaceholder: true,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context).primaryColor,
                                            width: 2.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context).buttonColor,
                                            width: 2.0),
                                      ),
                                      filled: false,
                                      fillColor: Colors.black45,
                                      hintText: 'Username',
                                      hintStyle: TextStyle(
                                          color: Colors.black),
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: Theme.of(context).primaryColor,
                                      ),

                                      //labelText: 'Title',
                                    ),
                                    obscureText: false,
                                    onSaved: (String email) {},
                                  ),
                                ),
                                Container(
                                  margin:
                                  EdgeInsets.only(bottom: 10, left: 10, right: 10),
                                  child: TextFormField(
                                    cursorColor: Colors.black45,
                                    style: TextStyle(color: Colors.black45),
                                    focusNode: _passwordNode,
                                    controller: _passwordController,
                                    decoration: InputDecoration(
                                      hasFloatingPlaceholder: true,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context).primaryColor,
                                            width: 2.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context).buttonColor,
                                            width: 2.0),
                                      ),
                                      filled: false,
                                      fillColor: Colors.black45,
                                      hintText: 'Password',
                                      hintStyle: TextStyle(
                                          color: Theme.of(context).primaryColor),
                                      prefixIcon: Icon(
                                        Icons.lock_outline,
                                        color: Theme.of(context).primaryColor,
                                      ),

                                      //labelText: 'Title',
                                    ),
                                    obscureText: true,
                                    validator: validations.validatePassword,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: 400,
                                  child: ButtonTheme(
                                    minWidth: 420.0,
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
                                          // _handleSubmitted();
                                        }),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: 400,
                                  child: ButtonTheme(
                                    minWidth: 420.0,
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
                          ),),

                        ],
                      ),
                    )),
                Center(
                  child: InkWell(
                    child: Text("Reset Password",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white)),
                    onTap: (){},
                  ),
                ),
                Center(
                  child: InkWell(
                    child: Text("FahamuTech @ 2020",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white),),
                    onTap: (){},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
