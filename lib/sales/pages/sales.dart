import 'package:flutter/material.dart';

import '../../core/services/util.dart';
import '../components/top_bar.dart';

class SalesPage extends StatelessWidget {
  const SalesPage({Key key}) : super(key: key);

  @override
  Widget build(args) {
    return Scaffold(
      appBar: salesTopBar(title: "Sales"),
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
    );
  }
}
