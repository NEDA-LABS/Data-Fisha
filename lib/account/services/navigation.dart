import 'package:flutter/material.dart';
import 'package:smartstock/account/pages/ProfileAccountIndex.dart';
import 'package:smartstock/account/pages/profile.dart';
import 'package:smartstock/account/pages/users.dart';
import 'package:smartstock/core/models/menu.dart';

MenuModel getAccountMenu(BuildContext context) {
  return MenuModel(
    name: 'Account',
    icon: const Icon(Icons.supervised_user_circle),
    link: '/account/',
    // onClick: () {
    //   Navigator.of(context).pushAndRemoveUntil(
    //       MaterialPageRoute(
    //           builder: (context) =>
    //               ProfileIndexPage(pages: _pagesMenu(context)),
    //           settings: const RouteSettings(name: 'r_account')),
    //       (route) => route.settings.name != 'r_account');
    // },
    roles: ['*'],
  );
}
