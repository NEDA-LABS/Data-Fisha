import 'package:flutter/material.dart';
import 'package:smartstock/sales/models/cart.model.dart';

typedef OnCheckout = Function(List<CartModel> carts, VoidCallback clearCart);
