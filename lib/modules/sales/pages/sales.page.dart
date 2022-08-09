import 'package:flutter/material.dart';
import 'package:smartstock_pos/modules/sales/components/sales.component.dart';
import 'package:smartstock_pos/util.dart';

class SalesPage extends StatelessWidget {
  @override
  Widget build(args) {
    return Scaffold(
      appBar: SalesComponents().salesTopBar(title: "Sales"),
      body: Builder(
        builder: (context) => SafeArea(
          child: Center(
            child: ListView(
              children: <Widget>[
                FlatButton(
                  onPressed: () => navigateTo('/sales/retail'),
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
                  onPressed: () => navigateTo('/sales/whole'),
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
