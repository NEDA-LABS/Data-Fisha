import 'package:flutter/material.dart';

class MenuModel {
  final String name;
  final List<SubMenuModule> pages;
  final String link;
  final List<String> roles;
  final Icon icon;

  MenuModel({
    @required this.name,
    @required this.icon,
    @required this.link,
    @required this.roles,
    @required this.pages,
  });
}

class SubMenuModule {
  final String name;
  final String link;
  final List<String> roles;
  final Function onClick;

  SubMenuModule({
    @required this.name,
    @required this.link,
    @required this.roles,
    @required this.onClick,
  });
}
