import 'package:flutter/material.dart';
import 'package:smartstock/account/components/profile_form.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/bottom_bar.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsivePage(
      office: 'Menu',
      current: '/account/',
      sliverAppBar: StockAppBar(title: "Profile", showBack: false, backLink: '/account/', context: context),
      menus: moduleMenus(),
      onBody: (d) => Scaffold(
        drawer: d,
        body: const ProfileForm(),
        bottomNavigationBar: bottomBar(2, moduleMenus(), context),
      ),
    );
  }
}
