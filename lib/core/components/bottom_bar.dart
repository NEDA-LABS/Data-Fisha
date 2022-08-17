import 'package:flutter/material.dart';

Widget bottomBar(int selected) => Builder(
      builder: (context) => BottomNavigationBar(
        currentIndex: selected,
        selectedItemColor: Theme.of(context).primaryColorDark,
        // unselectedItemColor: Theme.of(context).primaryColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.point_of_sale),
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
      ),
    );
