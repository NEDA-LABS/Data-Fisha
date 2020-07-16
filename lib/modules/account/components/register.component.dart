import 'package:flutter/material.dart';

class RegisterComponents {
  Step get _personalDetails {
    return Step(
        content: Container(
          color: Colors.red,
        ),
        title: Text("Personal Details"));
  }

  Step get _businessDetails {
    return Step(
        content: Container(
          color: Colors.blue,
        ),
        title: Text("Business Details"));
  }

  Step get _loginDetails {
    return Step(
        content: Container(
          color: Colors.blue,
        ),
        title: Text("Login Details"));
  }

  Widget get registerForm {
    return Stepper(
      currentStep: 0,
      steps: [
        this._personalDetails,
        this._businessDetails,
        this._loginDetails,
      ],
    );
  }
}
