import 'package:bfastui/bfastui.dart';
import 'package:flutter/material.dart';

class BottomBarComponents {
  Widget bottomBar(int currentIndex) {
    return BFastUI.component().custom(
      (context) => BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Theme.of(context).primaryColorDark,
        unselectedItemColor: Theme.of(context).primaryColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shop),
            label: 'Sales',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Purchases',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Stocks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Account',
          ),
        ],
//        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
