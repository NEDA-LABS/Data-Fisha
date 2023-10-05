import 'package:flutter/material.dart';
import 'package:smartstock/account/components/payment_body.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/HeadineLarge.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/services/util.dart';

class PaymentPage extends StatelessWidget {
  final dynamic subscription;

  const PaymentPage({
    Key? key,
    required this.subscription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BodyLarge(text: 'Bills Payment'),
      ),
      body: PaymentBody(subscription: subscription),
    );
  }
}
