import 'package:flutter/material.dart';

class ProductFormState extends ChangeNotifier{
  Map<String, dynamic> product = {};
  Map<String, dynamic> error = {};
  updateFormState(Map<String,dynamic> data){
    product.addAll(data);
  }
  refresh()=>notifyListeners();

  create(){

  }
}