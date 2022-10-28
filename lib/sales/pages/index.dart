import 'package:flutter/material.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/bottom_bar.dart';
import 'package:smartstock/core/components/index_page.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/switch_to_item.dart';
import 'package:smartstock/core/components/top_bar.dart';
import 'package:smartstock/core/models/external_service.dart';
import 'package:smartstock/sales/services/navigation.dart';

class SalesPage extends StatelessWidget {
  final List<ExternalService> services;

  const SalesPage({required this.services, Key? key}) : super(key: key);

  @override
  Widget build(context) {
    return responsiveBody(
      office: 'Menu',
      current: '/sales/',
      menus: moduleMenus(),
      onBody: (x) => Scaffold(
        appBar: StockAppBar(title: "Sales", showBack: false),
        drawer: x,
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 790),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  switchToTitle(),
                  Wrap(children: [
                    ...switchToItems(salesMenu().pages),
                    // ...switchToExternalService(services, '/sales')
                  ]),
                  // Text('${services.length}')
                  // salesSummary(),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: bottomBar(1, moduleMenus(), context),
      ),
    );
  }
}
