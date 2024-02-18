import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/TextInput.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/sales/models/cart.model.dart';

class SaleCheckoutDialog extends StatefulWidget {
  final List<CartModel> carts;
  const SaleCheckoutDialog(this.carts, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<SaleCheckoutDialog> {
  dynamic _discount;

  _updateState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(child: BodyLarge(text: "Header",),),
        Row(
          children: [
            Expanded(
              child: TextInput(onText: (p0) {

              },),
            ),
            WhiteSpacer(width: 8),
            Expanded(
              child: TextInput(onText: (p0) {

              },),
            ),
            WhiteSpacer(width: 8),
            Expanded(
              child: TextInput(onText: (p0) {

              },),
            ),
            WhiteSpacer(width: 8),
          ],
        )
      ],
    );
  }
}
