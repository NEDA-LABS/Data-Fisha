import 'package:flutter/material.dart';
import 'package:smartstock/account/pages/ProfileAccountIndex.dart';
import 'package:smartstock/account/pages/profile.dart';
import 'package:smartstock/account/pages/users.dart';
import 'package:smartstock/core/models/menu.dart';

List<SubMenuModule> _pagesMenu(BuildContext context) {
  pageNav(Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }

  return [
    SubMenuModule(
      name: 'Profile',
      link: '/account/profile',
      svgName: 'item_icon.svg',
      icon: Icons.person,
      roles: ["*"],
      onClick: () => pageNav(const ProfilePage()),
    ),
    SubMenuModule(
      name: 'Users',
      link: '/account/users',
      icon: Icons.groups,
      svgName: 'item_icon.svg',
      roles: ["*"],
      onClick: () => pageNav(const UsersPage()),
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

MenuModel getAccountMenu(BuildContext context) {
  return MenuModel(
    name: 'Account',
    icon: const Icon(Icons.supervised_user_circle),
    link: '/account/',
    onClick: () {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) =>
                  ProfileIndexPage(pages: _pagesMenu(context)),
              settings: const RouteSettings(name: 'r_account')),
          (route) => route.settings.name != 'r_account');
    },
    roles: ['*'],
    pages: _pagesMenu(context),
  );
}
