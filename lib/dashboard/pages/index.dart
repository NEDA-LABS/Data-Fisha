import 'package:flutter/material.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/bottom_bar.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/top_bar.dart';

class DashboardIndexPage extends StatelessWidget {
  const DashboardIndexPage({Key? key}) : super(key: key);

  @override
  Widget build(context) => responsiveBody(
        office: 'Menu',
        current: '/dashboard/',
        menus: moduleMenus(),
        onBody: (d) => Scaffold(
            drawer: d,
            appBar: StockAppBar(title: "Dashboard", showBack: false),
            body: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Center(
                    child: Container(
                        constraints: const BoxConstraints(maxWidth: 790),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // stocksSummary()
                            ])))),
            bottomNavigationBar: bottomBar(0, moduleMenus(), context)),
      );
}
