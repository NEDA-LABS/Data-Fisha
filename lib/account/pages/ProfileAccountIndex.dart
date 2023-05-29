import 'package:flutter/material.dart';
import 'package:smartstock/account/pages/profile.dart';
import 'package:smartstock/account/pages/users.dart';
import 'package:smartstock/core/components/SwitchToPageMenu.dart';
import 'package:smartstock/core/components/SwitchToTitle.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';
import 'package:smartstock/core/services/util.dart';

import '../../core/models/menu.dart';

class ProfileIndexPage extends StatelessWidget {
  const ProfileIndexPage({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    return ResponsivePage(
      office: 'Menu',
      current: '/account/',
      staticChildren: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SwitchToTitle(),
            SwitchToPageMenu(pages: _pagesMenu(context))
          ],
        )
      ],
      sliverAppBar: getSliverSmartStockAppBar(
          title: "My Account", showBack: false, context: context),
      // onBody: (x) => Scaffold(
      //   drawer: x,
      //   body: ,
      //   bottomNavigationBar: bottomBar(1, moduleMenus(), context),
      // ),
    );
  }

  List<ModulePageMenu> _pagesMenu(BuildContext context) {
    pageNav(Widget page) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
    }

    return [
      ModulePageMenu(
        name: 'Profile',
        link: '/account/profile',
        svgName: 'item_icon.svg',
        icon: Icons.person,
        roles: ["*"],
        onClick: () => pageNav(ProfilePage()),
      ),
      ModulePageMenu(
        name: 'Users',
        link: '/account/users',
        icon: Icons.groups,
        svgName: 'item_icon.svg',
        roles: ["*"],
        onClick: () => pageNav(UsersPage()),
      ),
      // SubMenuModule(
      //   name: 'Payment',
      //   link: '/account/bill',
      //   svgName: 'item_icon.svg',
      //   roles: [],
      //   onClick: () {},
      // )
    ];
  }
}
