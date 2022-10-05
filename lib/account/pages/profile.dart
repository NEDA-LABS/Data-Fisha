import 'package:flutter/material.dart';
import 'package:smartstock/account/components/profile_form.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/bottom_bar.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/top_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return responsiveBody(
      office: 'Menu',
      current: '/account/',
      menus: moduleMenus(),
      onBody: (d) => Scaffold(
        drawer: d,
        appBar: StockAppBar(title: "Profile", showBack: false),
        body: const ProfileForm(),
        bottomNavigationBar: bottomBar(3, moduleMenus(), context),
      ),
    );
  }
}
