import 'package:flutter/material.dart';
import 'package:smartstock/account/components/payment_body.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/bottom_bar.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsivePage(
      office: 'Menu',
      current: '/account/',
      menus: getAppModuleMenus(context),
      sliverAppBar: getSliverSmartStockAppBar(title: "Payment", showBack: true, backLink: '/account/', context: context,),
      onBody: (d) => Scaffold(
        drawer: d,
        body: const PaymentBody(),
        bottomNavigationBar: bottomBar(3, getAppModuleMenus(context), context),
      ),
    );
  }
}
