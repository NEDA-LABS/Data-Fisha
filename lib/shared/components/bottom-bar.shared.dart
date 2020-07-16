import 'package:bfastui/bfastui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BottomBarComponents {
  Widget  bottomBar(int currentIndex) {
    return BFastUI.component().custom(
      (context) => BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Theme.of(context).primaryColorDark,
        unselectedItemColor: Theme.of(context).primaryColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            title: Text('Dashboard'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shop),
            title: Text('Sales'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            title: Text('Purchases'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            title: Text('Stocks'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Account'),
          ),
        ],
//        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
