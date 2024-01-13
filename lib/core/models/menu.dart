import 'package:flutter/material.dart';
import 'package:smartstock/core/pages/page_base.dart';

class ModuleMenu {
  final String name;
  final String link;
  final PageBase page;
  final VoidCallback? onClick;
  final List<String> roles;
  final Icon icon;
  final List<ModuleMenu>? children;

  ModuleMenu({
    required this.name,
    required this.icon,
    required this.link,
    required this.roles,
    required this.page,
    this.children,
    this.onClick,
  });
}

class ModulePageMenu {
  final String name;
  final String link;
  final List<String> roles;
  final Function() onClick;
  final IconData? icon;
  final String? svgName;

  ModulePageMenu(
      {required this.name,
      required this.link,
      required this.roles,
      required this.onClick,
      this.svgName = '',
      this.icon});
}

class ContextMenu {
  final String name;
  final String detail;
  final Function() pressed;

  ContextMenu({required this.name, this.detail = '', required this.pressed});
}
