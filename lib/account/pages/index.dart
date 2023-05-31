import 'package:flutter/material.dart';
import 'package:smartstock/account/pages/profile.dart';
import 'package:smartstock/account/pages/users.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/SwitchToPageMenu.dart';
import 'package:smartstock/core/components/SwitchToTitle.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/util.dart';

class ProfileIndexPage extends StatelessWidget {
  final OnChangePage onChangePage;
  final OnBackPage onBackPage;

  const ProfileIndexPage({
    required this.onBackPage,
    required this.onChangePage,
    Key? key,
  }) : super(key: key);

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
        title: "My Account",
        showBack: false,
        context: context,
      ),
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
        onClick: () => onChangePage(ProfilePage(onBackPage: onBackPage)),
      ),
      ModulePageMenu(
        name: 'Users',
        link: '/account/users',
        icon: Icons.groups,
        svgName: 'item_icon.svg',
        roles: ["*"],
        onClick: () => onChangePage(
          UsersPage(
            onBackPage: onBackPage,
            onChangePage: onChangePage,
          ),
        ),
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
