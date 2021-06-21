import 'package:bfastui/adapters/page.adapter.dart';
import 'package:bfastui/bfastui.dart';
import 'package:flutter/material.dart';
import 'package:smartstock_pos/modules/sales/components/sales.component.dart';

class SalesPage extends PageAdapter {
  @override
  Widget build(args) {
    return Scaffold(
      appBar: SalesComponents().salesTopBar(title: "Sales"),
      body: BFastUI.component().custom(
        (context) => SafeArea(
          child: Center(
            child: ListView(
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    BFastUI.navigation(moduleName: 'sales').to('/sales/retail');
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.shopping_cart,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    title: Text('Retails'),
                  ),
                ),
                Divider(),
                FlatButton(
                  onPressed: () {
                    BFastUI.navigation(moduleName: 'sales').to('/sales/whole');
                  },
                  child: ListTile(
                    leading: Icon(Icons.local_shipping,
                        color: Theme.of(context).primaryColorDark),
                    title: Text('Wholesale'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
