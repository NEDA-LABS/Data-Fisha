import 'package:bfastui/adapters/page.dart';
import 'package:bfastui/bfastui.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/shared/drawer.dart';

class SalesPage extends BFastUIPage {
  @override
  Widget build(args) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sales"),
          actions: <Widget>[
            BFastUI.component().custom(
              (context) => IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: () {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("Show logout options"),
                  ));
                },
              ),
            ),
          ],
        ),
        // todo: drawer is not working, must be fixed
        drawer: Drawer(child: DrawerComponents().drawer),
        body: SafeArea(
          child: Center(
            child: ListView(
              children: <Widget>[Text("Sales page")],
            ),
          ),
        ));
  }
}
