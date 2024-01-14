import 'package:flutter/material.dart';
import 'package:smartstock/core/components/AppMenu.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/helpers/util.dart';

class MenuDrawer extends StatefulWidget {
  final Map currentUser;
  final List<ModuleMenu> menus;
  final String currentPage;
  final double cWidth;
  final OnChangePage onChangePage;
  final OnGeAppMenu onGetModulesMenu;
  final OnGetInitialPage onGetInitialModule;

  const MenuDrawer({
    required this.currentUser,
    required this.onGetModulesMenu,
    required this.menus,
    required this.onChangePage,
    required this.onGetInitialModule,
    required this.currentPage,
    this.cWidth = 250,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<MenuDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: widget.cWidth,
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: AppMenu(
          currentPage: widget.currentPage,
          currentUser: widget.currentUser,
          onGetModulesMenu: widget.onGetModulesMenu,
          menus: widget.menus,
          onChangePage: widget.onChangePage,
          onGetInitialModule: widget.onGetInitialModule),
    );
  }
}
