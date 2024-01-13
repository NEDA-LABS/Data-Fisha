import 'package:bfast/util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/account/pages/ChooseShopPage.dart';
import 'package:smartstock/core/components/BodyMedium.dart';
import 'package:smartstock/core/components/LabelLarge.dart';
import 'package:smartstock/core/components/TitleMedium.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/with_active_shop.dart';
import 'package:smartstock/core/helpers/configs.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/account.dart';
import 'package:smartstock/core/services/rbac.dart';
import 'package:smartstock/core/services/util.dart';

class AppMenu extends StatefulWidget {
  final Map currentUser;
  final List<ModuleMenu> menus;
  final String? current;
  final OnChangePage onChangePage;
  final OnGeAppMenu onGetModulesMenu;
  final OnGetInitialPage onGetInitialModule;

  const AppMenu({
    required this.currentUser,
    required this.onGetModulesMenu,
    required this.menus,
    required this.onChangePage,
    required this.onGetInitialModule,
    this.current,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<AppMenu> {
  @override
  Widget build(BuildContext context) {
    return WithActiveShop(onChild: _modulesMenuContent);
  }

  Widget _modulesMenuContent(Map shop) {
    var getOfficeName = compose([propertyOr('businessName', (p0) => 'Menu')]);
    var getOfficeLogo =
        compose([propertyOrNull('logo'), propertyOrNull('ecommerce')]);
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: _getContainerDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              controller: ScrollController(),
              children: [
                const WhiteSpacer(height: 24),
                _officeName('${getOfficeName(shop)}'),
                _officeLogo('${getOfficeLogo(shop)}'),
                _changeOfficeTextButton(),
                ..._getMenuItems(),
                _logOutMenuItem(context)
              ],
            ),
          ),
          _getVersion()
        ],
      ),
    );
  }

  Widget _officeName(String? name) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TitleMedium(text: '$name'),
      ),
    );
  }

  Widget _officeLogo(String? url) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(80),
              color: Theme.of(context).colorScheme.tertiary,
            ),
            child: '$url'.startsWith('http')
                ? Image.network('$url', errorBuilder: (a, b, c) => Container())
                : Container()),
      ),
    );
  }

  Widget _changeOfficeTextButton() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChooseShopPage(
                  onGetModulesMenu: widget.onGetModulesMenu,
                  onGetInitialModule: widget.onGetInitialModule,
                ),
              ),
            );
          },
          child: const LabelLarge(text: 'Change Office'),
        ),
      ),
    );
  }

  BoxDecoration _getSelectedDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.secondaryContainer,
      borderRadius: const BorderRadius.all(
        Radius.circular(8),
      ),
    );
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

  _logOutMenuItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListTile(
        leading: Icon(Icons.exit_to_app,
            color: Theme.of(context).colorScheme.primary),
        title: const BodyMedium(text: 'Sign out'),
        onTap: () {
          logOut(context, widget.onGetModulesMenu, widget.onGetInitialModule);
        },
      ),
    );
  }

  BoxDecoration _getContainerDecoration() {
    return BoxDecoration(
      border: Border(
        right: BorderSide(
          color: Theme.of(context).colorScheme.onBackground,
          width: .2,
        ),
      ),
    );
  }

  Widget _getVersion() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: Text('v$version')),
    );
  }

  List<Widget> _getMenuItems() {
    var menus = widget.menus
        .where((e) => hasRbaAccess(widget.currentUser, e.roles, e.link))
        .toList();
    return menus.map<Widget>((dynamic item) {
      item as ModuleMenu;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          // decoration: item.link == widget.current
          //     ? _getSelectedDecoration(context)
          //     : null,
          child: itOrEmptyArray(item.children).isNotEmpty
              ? _getMultipleItemsMenu(item)
              : _getSingleItemMenu(item),
        ),
      );
    }).toList();
  }

  Widget _getSingleItemMenu(ModuleMenu item) {
    return ListTile(
      leading:
          item.link == widget.current ? _getSelectedIcon(context) : item.icon,
      title: BodyMedium(text: item.name),
      onTap: () => widget.onChangePage(item.page),
      dense: true,
    );
  }

  Widget _getMultipleItemsMenu(ModuleMenu item) {
    return ExpansionPanelList(
      elevation: 0,
      expandedHeaderPadding: EdgeInsets.all(0),
      materialGapSize: 0,
      expandIconColor: Theme.of(context).colorScheme.primary,
      expansionCallback: (panelIndex, isExpanded) {},
      children: [
        ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return ListTile(
              leading: item.icon,
              title: BodyMedium(text: item.name),
              // onTap: null,
            );
          },
          body: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: itOrEmptyArray(item.children)
                  .map((e) => _getSingleItemMenu(e))
                  .toList(),
            ),
          ),
          canTapOnHeader: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          isExpanded: true,
        )
      ],
    );
  }
}
