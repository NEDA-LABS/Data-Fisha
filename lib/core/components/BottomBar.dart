import 'package:flutter/material.dart';
import 'package:smartstock/core/components/AppMenu.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/full_screen_dialog.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/models/menu.dart';

class AppBottomBar extends StatefulWidget {
  final Map currentUser;
  final String currentPage;
  final List<ModuleMenu> menus;
  final OnChangePage onChangePage;
  final OnGeAppMenu onGetModulesMenu;
  final OnGetInitialPage onGetInitialModule;

  const AppBottomBar({
    required this.menus,
    required this.onChangePage,
    required this.onGetModulesMenu,
    required this.onGetInitialModule,
    required this.currentUser,
    required this.currentPage,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<AppBottomBar> {
  @override
  Widget build(BuildContext context) {
    var size = widget.menus.length;
    return BottomNavigationBar(
      currentIndex: size > 3 ? 3 : 0,
      backgroundColor: Theme.of(context).colorScheme.surface,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      selectedFontSize: 10,
      unselectedFontSize: 10,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Theme.of(context).colorScheme.primary,
      onTap: (index) {
        if (widget.menus.length > 3
            ? (index == 3)
            : (index == widget.menus.length)) {
          showFullScreeDialog(context, (p0) {
            return Scaffold(
              appBar: AppBar(
                title: const BodyLarge(text: 'Menu'),
                centerTitle: true,
              ),
              backgroundColor: Theme.of(context).colorScheme.surface,
              body: AppMenu(
                currentPage: widget.currentPage,
                currentUser: widget.currentUser,
                onGetModulesMenu: widget.onGetModulesMenu,
                menus: widget.menus,
                onChangePage: widget.onChangePage,
                onGetInitialModule: widget.onGetInitialModule,
                onDoneNavigate: () {
                  Navigator.of(context).maybePop();
                },
              ),
            );
          });
          return;
        }
        widget.onChangePage(widget.menus[index].page);
      },
      items: [
        ...widget.menus
            .sublist(0, size <= 3 ? size : 3)
            .map<BottomNavigationBarItem>((e) {
          return BottomNavigationBarItem(icon: e.icon, label: e.name);
        }),
        const BottomNavigationBarItem(icon: Icon(Icons.dehaze), label: 'Menu')
      ],
    );
  }
}
