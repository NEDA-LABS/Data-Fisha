import 'package:flutter/material.dart';

class BottomBarComponents {
  Widget bottomBar(int currentIndex) {
    return Builder(
      builder: (context) {
        return BottomNavigationBar(
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
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.receipt),
              //   label: 'Purchases',
              // ),
              BottomNavigationBarItem(
                icon: Icon(Icons.store),
                label: 'Stocks',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.dehaze),
                label: 'Menu',
              ),
            ],
//        backgroundColor: Theme.of(context).primaryColor,
        );
      }
    );
  }
}
