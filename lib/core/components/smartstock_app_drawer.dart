import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/account/pages/ChooseShopPage.dart';
import 'package:smartstock/configs.dart';
import 'package:smartstock/core/components/BodyMedium.dart';
import 'package:smartstock/core/components/BodySmall.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/account.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/cache_user.dart';
import 'package:smartstock/core/services/rbac.dart';
import 'package:smartstock/core/services/util.dart';

class SmartStockAppDrawer extends Drawer {
  final List<ModuleMenu> menus;
  final String? current;
  final double cWidth;
  final OnChangePage onChangePage;
  final OnGetModulesMenu onGetModulesMenu;
  final OnGetInitialPage onGetInitialModule;

  const SmartStockAppDrawer({
    required this.onGetModulesMenu,
    required this.menus,
    required this.onChangePage,
    required this.onGetInitialModule,
    this.current,
    this.cWidth = 250,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: cWidth,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(0),
            bottomRight: Radius.circular(0)),
      ),
      child: _modulesMenuContent(menus, current),
    );
  }

  _modulesMenuContent(List<ModuleMenu> allMenus, String? current) {
    var getOfficeName = propertyOr('businessName', (p0) => 'Menu');
    var getOfficeLogo = compose(
        [propertyOr('logo', (p0) => ''), propertyOr('ecommerce', (p0) => {})]);
    return FutureBuilder(
      initialData: const {"shop": {}, "menus": []},
      future: _future(allMenus),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView(
                    controller: ScrollController(),
                    children: [
                      _header(
                        getOfficeName(
                            propertyOr('shop', (p0) => {})(snapshot.data)),
                        getOfficeLogo(
                            propertyOr('shop', (p0) => {})(snapshot.data)),
                      ),
                      ...propertyOr('menus', (p0) => [])(snapshot.data)
                          .map<Widget>(_moduleMenuItems(current, context))
                          .toList(),
                      _logOutMenuItem(context)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Text('v$version')),
                )
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Future _future(List<ModuleMenu> menus) async {
    var shop = await getActiveShop();
    var user = await getLocalCurrentUser();
    var m = menus
        .where((element) => hasRbaAccess(user, element.roles, element.link))
        .toList();
    return {"shop": shop, "menus": m};
  }

  Widget _header(String? currentOffice, logoUrl) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _officeName('$currentOffice'),
          _officeLogo(logoUrl),
          _changeOfficeTextButton()
        ],
      ),
    );
  }

  Widget _officeName(String? name) => Builder(
      builder: (context) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '$name',
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 12,
                // color: Theme.of(context).primaryColor,
              ),
            ),
          ));

  Widget _officeLogo(String? url) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Builder(
        builder: (context) => Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(80),
            color: Theme.of(context).colorScheme.tertiary,
          ),
          child: url == null || true
              ? Container()
              : url.isEmpty
                  ? Container()
                  : Image.network(url),
        ),
      ),
    );
  }

  Widget _changeOfficeTextButton() {
    return Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChooseShopPage(
                  onGetModulesMenu: onGetModulesMenu,
                  onGetInitialModule: onGetInitialModule,
                ),
              ),
            );
          },
          child: const BodySmall(
            text: 'Change Office',
            // style: TextStyle(
            //   fontSize: 16,
            //   fontWeight: FontWeight.w400,
            //   // color: Theme.of(context).primaryColor,
            // ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _getSelectedDecoration(BuildContext context) {
    return BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: const BorderRadius.all(Radius.circular(8)));
  }

  Widget _getSelectedIcon(BuildContext context) {
    return Container(
      width: 6,
      margin: const EdgeInsets.symmetric(vertical: 13),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
    );
  }

  _moduleMenuItems(String? current, BuildContext context) {
    return (dynamic item) {
      item as ModuleMenu;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          decoration:
              item.link == current ? _getSelectedDecoration(context) : null,
          child: ListTile(
            leading:
                item.link == current ? _getSelectedIcon(context) : item.icon,
            title: BodyMedium(text: item.name),
            onTap: () {
              onChangePage(item.page);
              // print('TAPPED');
              // item.onClick != null ? item.onClick!() : navigateTo(item.link);
            },
          ),
        ),
      );
    };
  }

  _logOutMenuItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListTile(
        leading: const Icon(Icons.exit_to_app),
        title: const BodyMedium(text: 'Sign out'),
        onTap: () {
          logOut(context, onGetModulesMenu, onGetInitialModule);
        },
      ),
    );
  }
}
