import 'package:flutter/material.dart';
import 'package:smartstock/account/components/profile_form.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

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
      menus: getAppModuleMenus(context),
      staticChildren: const [ProfileForm()],
    );
  }
}
