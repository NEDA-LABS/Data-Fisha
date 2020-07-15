import 'package:email_validator/email_validator.dart';

class Validations{
  String validateName(String value) {
    if (value.isEmpty) return 'Name is required.';
    final RegExp nameExp = new RegExp(r'^[A-za-z ]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alphabetical characters.';
    return null;
  }

  String validateEmail(String value) {
    if (value.isEmpty) return 'Email is required.';
    final bool isValid = EmailValidator.validate(value);
    if (!isValid) return 'Invalid email address';
    return null;
  }

  String validateMobileNumber(String value) {
    if (value.isEmpty) return 'Phone number is required.';
    final RegExp nameExp = new RegExp(r'^(?:[+0]9)?[0-9]{10}$');
    if (!nameExp.hasMatch(value)) return 'Invalid Phone number';
    return null;

  }


  String validatePassword(String value) {
    if (value.isEmpty) return 'Password is missing or invalid.';
    return null;
  }

  String validateUserName(String value) {
    if (value.isEmpty) return 'Username is missing or invalid.';
    return null;
  }

}