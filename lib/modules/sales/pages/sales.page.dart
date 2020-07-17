import 'package:bfastui/adapters/page.dart';
import 'package:bfastui/bfastui.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/modules/account/states/login.state.dart';

class SalesPage extends BFastUIPage {
  @override
  Widget build(args) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sales"),
          actions: <Widget>[
            BFastUI.component().consumer<LoginPageState>(
              (context, state) => PopupMenuButton(
                onSelected: (value) {
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: FlatButton(
                      onPressed: () {
                        state.logOut();
                      },
                      child: Row(
                        children: [
                          Text("Logout"),
                          Container(
                            width: 4,
                            height: 0,
                          ),
                          Icon(
                            Icons.exit_to_app,
                            color: Theme.of(context).primaryColorDark,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
                icon: Icon(Icons.account_circle),
              ),
            ),
          ],
        ),
        body: BFastUI.component().custom(
          (context) => SafeArea(
            child: Center(
              child: ListView(
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      BFastUI.navigation(moduleName: 'sales')
                          .to('/sales/retail');
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
                      BFastUI.navigation(moduleName: 'sales')
                          .to('/sales/whole');
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
        ));
  }
}
