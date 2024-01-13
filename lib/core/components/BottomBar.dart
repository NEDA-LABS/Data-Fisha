import 'package:flutter/material.dart';
import 'package:smartstock/account/pages/ChooseShopPage.dart';
import 'package:smartstock/core/components/AppMenu.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/BodyMedium.dart';
import 'package:smartstock/core/components/LabelMedium.dart';
import 'package:smartstock/core/components/AppDrawer.dart';
import 'package:smartstock/core/components/full_screen_dialog.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/account.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/util.dart';

class AppBottomBar extends StatefulWidget {
  final Map currentUser;
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
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<AppBottomBar> {
  String currentOffice = '';

  @override
  void initState() {
    getActiveShop().then((value) {
      if (mounted) {
        setState(() {
          currentOffice = propertyOr('businessName', (p0) => '')(value);
        });
      }
    }).catchError((e) {});
    super.initState();
  }

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
          fullScreeDialog(context, (p0) {
            return Scaffold(
              appBar: AppBar(title: const BodyLarge(text: 'Menu'), centerTitle: true,),
              backgroundColor: Theme.of(context).colorScheme.surface,
              body: AppMenu(
                currentUser: widget.currentUser,
                onGetModulesMenu: widget.onGetModulesMenu,
                menus: widget.menus,
                onChangePage: widget.onChangePage,
                onGetInitialModule: widget.onGetInitialModule,
              ),
            );
          });
          // showModalBottomSheet(
          //   context: context,
          //   builder: (context) {
          //     return Container(
          //       color: Theme.of(context).colorScheme.background,
          //       child: Padding(
          //         padding: const EdgeInsets.symmetric(vertical: 16.0),
          //         child: ListView(
          //           shrinkWrap: true,
          //           children: [
          //             ...widget.menus
          //                 .map(
          //                   (e) => ListTile(
          //                     title: BodyMedium(text: e.name),
          //                     leading: e.icon,
          //                     trailing: const Icon(Icons.chevron_right),
          //                     onTap: () {
          //                       Navigator.of(context).maybePop();
          //                       widget.onChangePage(e.page);
          //                     },
          //                   ),
          //                 )
          //                 .toList(),
          //             ListTile(
          //               title: const BodyMedium(text: 'Change office'),
          //               subtitle: LabelMedium(text: currentOffice),
          //               leading: Icon(Icons.change_circle,
          //                   color: Theme.of(context).colorScheme.primary),
          //               // trailing: const Icon(Icons.chevron_right),
          //               onTap: () {
          //                 Navigator.of(context).push(
          //                   MaterialPageRoute(
          //                     builder: (context) => ChooseShopPage(
          //                       onGetModulesMenu: widget.onGetModulesMenu,
          //                       onGetInitialModule: widget.onGetInitialModule,
          //                     ),
          //                   ),
          //                 );
          //               },
          //             ),
          //             ListTile(
          //               title: const BodyMedium(text: 'Sign out'),
          //               leading: Icon(Icons.exit_to_app,
          //                   color: Theme.of(context).colorScheme.primary),
          //               // trailing: const Icon(Icons.chevron_right),
          //               onTap: () {
          //                 logOut(
          //                   context,
          //                   widget.onGetModulesMenu,
          //                   widget.onGetInitialModule,
          //                 );
          //               },
          //             )
          //           ],
          //         ),
          //       ),
          //     );
          //   },
          // );
          return;
        }
        if (widget.menus[index].onClick != null) {
          widget.onChangePage(widget.menus[index].page);
          // menus[index].onClick!();
        }
      },
      items: [
        ...widget.menus
            .sublist(0, size <= 3 ? size : 3)
            .map<BottomNavigationBarItem>(
              (e) => BottomNavigationBarItem(icon: e.icon, label: e.name),
            )
            .toList(),
        const BottomNavigationBarItem(icon: Icon(Icons.dehaze), label: 'Menu')
      ],
    );
  }
}
