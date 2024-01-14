import 'package:flutter/material.dart';
import 'package:smartstock/account/pages/profile.dart';
import 'package:smartstock/account/pages/users.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/SwitchToPageMenu.dart';
import 'package:smartstock/core/components/SwitchToTitle.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/core/helpers/util.dart';

class ProfileIndexPage extends PageBase {
  final OnChangePage onChangePage;
  final OnBackPage onBackPage;

  const ProfileIndexPage({
    required this.onBackPage,
    required this.onChangePage,
    Key? key,
  }) : super(key: key, pageName: 'ProfileIndexPage');

  @override
  State<StatefulWidget> createState()=> _State();

}

class _State extends State<ProfileIndexPage>{
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
      sliverAppBar: SliverSmartStockAppBar(
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
    return [
      ModulePageMenu(
        name: 'Profile',
        link: '/account/profile',
        svgName: 'item_icon.svg',
        icon: Icons.person,
        roles: ["*"],
        onClick: () => widget.onChangePage(ProfilePage(onBackPage: widget.onBackPage)),
      ),
      ModulePageMenu(
        name: 'Users',
        link: '/account/users',
        icon: Icons.groups,
        svgName: 'item_icon.svg',
        roles: ["*"],
        onClick: () => widget.onChangePage(
          UsersPage(
            onBackPage: widget.onBackPage,
            onChangePage: widget.onChangePage,
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