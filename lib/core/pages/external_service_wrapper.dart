import 'package:flutter/material.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/bottom_bar.dart';
import 'package:smartstock/core/components/index_page.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/switch_to_item.dart';
import 'package:smartstock/core/components/top_bar.dart';
import 'package:smartstock/sales/services/navigation.dart';

class ExternalServiceWrapperPage extends StatelessWidget {
  final String currentRoute;
  final int currentBottomIndex;
  final String title;
  final String backLink;
  final Widget child;
  final Function(dynamic)? onSearch;
  final Function()? onBack;
  final bool showSearch;

  const ExternalServiceWrapperPage({
    Key? key,
    required this.currentRoute,
    required this.title,
    required this.child,
    required this.currentBottomIndex,
    this.backLink = '',
    this.showSearch = false,
    this.onSearch,
    this.onBack,
  }) : super(key: key);

  @override
  Widget build(context) {
    return responsiveBody(
      office: 'Menu',
      current: currentRoute,
      menus: moduleMenus(),
      onBody: (x) => Scaffold(
        appBar: StockAppBar(
          title: title,
          showBack: backLink.isNotEmpty,
          backLink: backLink,
          showSearch: showSearch,
          onSearch: onSearch,
          onBack: onBack,
          searchHint: 'Type to search...',
        ),
        drawer: x,
        body: child,
        // bottomNavigationBar: bottomBar(1, moduleMenus(), context),
      ),
    );
  }
}
