import 'package:flutter/material.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/dashboard/pages/index.dart';

MenuModel dashboardMenu(BuildContext context) => MenuModel(
      name: 'Dashboard',
      icon: const Icon(Icons.dashboard),
      link: '/dashboard/',
      // onClick: () {
      //   Navigator.of(context).pushAndRemoveUntil(
      //       MaterialPageRoute(
      //           builder: (context) => DashboardIndexPage(onGetModulesMenu: ),
      //           settings: const RouteSettings(name: 'r_dashboard')),
      //       (route) => route.settings.name != 'r_dashboard');
      // },
      roles: ['admin'],
    );
