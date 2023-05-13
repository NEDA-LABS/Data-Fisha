import 'package:flutter/material.dart';

class MenuModel {
  final String name;
  // final Widget indexPage;
  final String link;
  final Function()? onClick;
  final List<String> roles;
  final Icon icon;

  MenuModel({
    required this.name,
    required this.icon,
    required this.link,
    required this.roles,
    // required t his.indexPage,
    this.onClick
  });
}

class SubMenuModule {
  final String name;
  final String link;
  final List<String> roles;
  final Function() onClick;
  final IconData? icon;
  final String? svgName;

  SubMenuModule({
    required this.name,
    required this.link,
    required this.roles,
    required this.onClick,
    this.svgName = '',
    this.icon
  });
}

class ContextMenu{
  final String name;
  final Function() pressed;
   ContextMenu({required this.name, required this.pressed});
}