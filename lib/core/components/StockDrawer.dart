import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/configurations.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/cache_user.dart';
import 'package:smartstock/core/services/rbac.dart';
import 'package:smartstock/core/services/util.dart';

class StockDrawer extends Drawer {
  final List<MenuModel> menus;
  final String? current;
  final double cWidth;

  const StockDrawer(
    this.menus,
    this.current, {
    Key? key,
    this.cWidth = 250,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: cWidth,
      child: _modulesMenuContent(menus, current),
    );
  }

  _modulesMenuContent(List<MenuModel> allMenus, String? current) {
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
                              propertyOr('shop', (p0) => {})(snapshot.data))),
                      ...propertyOr('menus', (p0) => [])(snapshot.data)
                          .map<Widget>(_moduleMenuItems(current, context))
                          .toList()
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

  Future _future(List<MenuModel> menus) async {
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
          onPressed: () => navigateTo('/account/shop'),
          child: const Text(
            'Change Office',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              // color: Theme.of(context).primaryColor,
            ),
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

  final _itemStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    // color: Color(0xFF1C1C1C),
  );

  _moduleMenuItems(String? current, BuildContext context) {
    return (dynamic item) {
      item as MenuModel;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          decoration: item.link == current ? _getSelectedDecoration(context) : null,
          child: ListTile(
            leading:
                item.link == current ? _getSelectedIcon(context) : item.icon,
            title: Text(item.name, style: _itemStyle),
            onTap: () => navigateTo(item.link),
          ),
        ),
        // : ExpansionTile(
        //     leading: current?.contains(item.link) ?? false
        //         ? _selectedIcon
        //         : item.icon,
        //     title: Text(item.name, style: _itemStyle),
        //     initiallyExpanded: current?.contains(item.link) ?? false,
        //     children: item.pages.map(_prepareSubMenuItem(current)).toList(),
        //   ),
      );
    };
  }

// Widget Function(SubMenuModule item) _prepareSubMenuItem(String? current) {
//   return (SubMenuModule item) {
//     return ListTile(
//         title: Text('             ${item.name}', style: _itemStyle),
//         onTap: () => navigateTo(item.link));
//   };
// }
}
