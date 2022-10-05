import 'package:flutter/material.dart';
import 'package:smartstock/account/components/payment_body.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/bottom_bar.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/top_bar.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return responsiveBody(
      office: 'Menu',
      current: '/account/',
      menus: moduleMenus(),
      onBody: (d) => Scaffold(
        drawer: d,
        appBar: StockAppBar(title: "Payment", showBack: false),
        body: const PaymentBody(),
        bottomNavigationBar: bottomBar(3, moduleMenus(), context),
      ),
    );
  }
}
