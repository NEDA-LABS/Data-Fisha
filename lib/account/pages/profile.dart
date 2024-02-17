import 'package:flutter/material.dart';
import 'package:smartstock/account/components/profile_form.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/core/helpers/util.dart';

class ProfilePage extends PageBase {
  final OnBackPage onBackPage;

  const ProfilePage({
    required this.onBackPage,
    Key? key,
  }) : super(key: key, pageName: 'ProfilePage');

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ProfilePage>{
  @override
  Widget build(BuildContext context) {
    return ResponsivePage(
      office: 'Menu',
      current: '/account/',
      sliverAppBar: SliverSmartStockAppBar(
        title: "Profile",
        showBack: true,
        onBack: widget.onBackPage,
        context: context,
      ),
      staticChildren: const [ProfileForm()],
    );
  }
}
