import 'package:flutter/material.dart';
import 'package:smartstock/account/components/payment_body.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/pages/page_base.dart';

class PaymentPage extends PageBase {
  final dynamic subscription;

  const PaymentPage({
    Key? key,
    required this.subscription,
  }) : super(key: key, pageName: 'PaymentPage');

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          widget.subscription != null && widget.subscription['force'] == true
              ? null
              : AppBar(
                  title: const BodyLarge(text: 'Subscription Payments'),
                ),
      body: PaymentBody(initialSubscription: widget.subscription),
    );
  }
}
