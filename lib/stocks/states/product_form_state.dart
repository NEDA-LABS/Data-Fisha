import 'package:flutter/material.dart';

class ProductFormState extends ChangeNotifier{
  Map<String, dynamic> productForm = {};
  Map<String, dynamic> errors = {};
  updateFormState(Map<String,dynamic> data){
    productForm.addAll(data);
  }
  refresh()=>notifyListeners();
}