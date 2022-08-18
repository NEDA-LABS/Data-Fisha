import 'package:flutter/material.dart';
import 'package:smartstock_pos/app.dart';
import 'package:smartstock_pos/core/components/bottom_bar.dart';
import 'package:smartstock_pos/core/components/drawer.dart';
import 'package:smartstock_pos/core/components/responsive_body.dart';

import '../../core/services/util.dart';
import '../components/top_bar.dart';

class SalesPage extends StatelessWidget {
  const SalesPage({Key key}) : super(key: key);

  @override
  Widget build(context) => responsiveBody(
      office: 'Menu',
      current: '/sales/',
      menus: moduleMenus(),
      onBody: (x)=>Scaffold(
        appBar: salesTopBar(title: "Sales", showBack: false),
        drawer: x,
        body: Builder(
          builder: (context) => SafeArea(
            child: Center(
              child: ListView(
                children: <Widget>[
                  TextButton(
                    onPressed: () => navigateTo('/sales/retail'),
                    child: ListTile(
                      leading: Icon(
                        Icons.shopping_cart,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      title: const Text('Retails'),
                    ),
                  ),
                  const Divider(),
                  TextButton(
                    onPressed: () => navigateTo('/sales/whole'),
                    child: ListTile(
                      leading: Icon(Icons.local_shipping,
                          color: Theme.of(context).primaryColorDark),
                      title: const Text('Wholesale'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: bottomBar(1, moduleMenus(), context),
      ));
}
