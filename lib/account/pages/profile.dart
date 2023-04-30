import 'package:flutter/material.dart';
import 'package:smartstock/account/components/profile_form.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';
import 'package:smartstock/core/services/util.dart';

class ProfilePage extends StatelessWidget {
  final OnGetModulesMenu onGetModulesMenu;
  const ProfilePage({Key? key, required this.onGetModulesMenu}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsivePage(
      office: 'Menu',
      current: '/account/',
      sliverAppBar: getSliverSmartStockAppBar(
          title: "Profile",
          showBack: true,
          // backLink: '/account/',
          onBack: () {
            Navigator.of(context).canPop()
                ? Navigator.of(context).pop()
                : Navigator.of(context).pushNamed('/');
          },
          context: context),
      menus: onGetModulesMenu(context),
      staticChildren: const [ProfileForm()],
    );
  }
}
