import 'package:flutter/material.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/dashboard/pages/index.dart';

List<SubMenuModule> _pagesMenu() =>
    [
      // SubMenuModule(
      //   name: 'Cash sale',
      //   link: '/dashboards/cash',
      //   svgName: 'product_icon.svg',
      //   roles: [],
      //   onClick: () {},
      // )
    ];

MenuModel dashboardMenu(BuildContext context) =>
    MenuModel(
      name: 'Dashboard',
      icon: const Icon(Icons.dashboard),
      link: '/dashboard/',
      onClick: () {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
            builder: (context) => DashboardIndexPage(),
            settings: RouteSettings(name: 'r_dashboard')), (route) => route.settings.name!='r_dashboard');
      },
      roles: ['admin'],
      pages: _pagesMenu(),
    );
