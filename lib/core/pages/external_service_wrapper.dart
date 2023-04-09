import 'package:flutter/material.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';

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
    return ResponsivePage(
      office: 'Menu',
      current: currentRoute,
      menus: getAppModuleMenus(context),
      sliverAppBar: getSliverSmartStockAppBar(
        title: title,
        showBack: backLink.isNotEmpty,
        backLink: backLink,
        showSearch: showSearch,
        onSearch: onSearch,
        onBack: onBack,
        searchHint: 'Type to search...',
        context: context,
      ),
      onBody: (x) => Scaffold(drawer: x, body: child),
    );
  }
}
