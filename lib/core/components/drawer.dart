import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/configurations.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/cache_user.dart';
import 'package:smartstock/core/services/rbac.dart';
import 'package:smartstock/core/services/util.dart';

drawer(List<MenuModel> menus, String current) {
  return Drawer(
    width: 250,
    backgroundColor: Colors.white,
    child: modulesMenuContent(menus, current),
  );
}

modulesMenuContent(List<MenuModel> allMenus, String current) {
  var getOfficeName = propertyOr('businessName', (p0) => 'Menu');
  var getOfficeLogo = compose([
    propertyOr(
        'logo',
        (p0) =>
            '' /*'https://bafkreiaitdtnqgwdrwvtfg2scoehxkaca2nfazn5cnvvp2gza46y6yqgme.ipfs.cf-ipfs.com/'*/),
    propertyOr('ecommerce', (p0) => {})
  ]);
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
                  shrinkWrap: true,
                  children: [
                    _header(
                        getOfficeName(
                            propertyOr('shop', (p0) => {})(snapshot.data)),
                        getOfficeLogo(
                            propertyOr('shop', (p0) => {})(snapshot.data))),
                    ...propertyOr('menus', (p0) => [])(snapshot.data)
                        .map<Widget>(_moduleMenuItems(current))
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
      .where((element) => hasRbaAccess(user, element.roles, null))
      .toList();
  return {"shop": shop, "menus": m};
}

Widget _header(String currentOffice, logoUrl) {
  return Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _officeName(currentOffice),
        _officeLogo(logoUrl),
        _changeOfficeTextButton()
      ],
    ),
  );
}

Widget _officeName(String name) => Builder(
    builder: (context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(name,
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 12,
                color: Theme.of(context).primaryColor))));

Widget _officeLogo(String url) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Builder(
      builder: (context) => Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(80),
            color: Theme.of(context).primaryColor),
        child: url.isEmpty ? Container() : Image.network(url),
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
        child: Text(
          'Change Office',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).primaryColor),
        ),
      ),
    ),
  );
}

_moduleMenuItems(String current) {
  return (dynamic item) {
    item as MenuModel;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ExpansionTile(
        leading: item.icon,
        title: Text(
          item.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        initiallyExpanded: current == item.link,
        children: [
          _subMenuItem(SubMenuModule(
              name: 'Summary',
              link: item.link,
              roles: item.roles,
              onClick: () {})),
          ...item.pages.map(_subMenuItem).toList()
        ],
      ),
    );
  };
}

Widget _subMenuItem(SubMenuModule item) {
  return InkWell(
    onTap: () => navigateTo(item.link),
    child: ListTile(
      dense: true,
      title: Text(
        '               ${item.name}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
      ),
    ),
  );
}
