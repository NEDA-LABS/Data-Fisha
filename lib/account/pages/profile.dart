import 'package:flutter/material.dart';
import 'package:smartstock/account/components/profile_form.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';
import 'package:smartstock/core/services/util.dart';

class ProfilePage extends StatelessWidget {
  final OnBackPage onBackPage;

  const ProfilePage({
    required this.onBackPage,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsivePage(
      office: 'Menu',
      current: '/account/',
      sliverAppBar: getSliverSmartStockAppBar(
        title: "Profile",
        showBack: true,
        onBack: onBackPage,
        context: context,
      ),
      staticChildren: const [ProfileForm()],
    );
  }
}
