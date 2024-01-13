import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/AppDrawer.dart';
import 'package:smartstock/core/components/BottomBar.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/cache_user.dart';
import 'package:smartstock/core/services/rbac.dart';
import 'package:smartstock/core/services/util.dart';

typedef ChildBuilder = Widget Function(BuildContext context, dynamic index);

class ResponsivePageLayout extends StatefulWidget {
  final Map currentUser;
  final String office;
  final String current;
  final bool showLeftDrawer;
  final List<ModuleMenu> menus;
  final Widget child;
  final OnChangePage onChangePage;
  final OnGeAppMenu onGetModulesMenu;
  final OnGetInitialPage onGetInitialModule;

  const ResponsivePageLayout({
    this.office = '',
    this.current = '/',
    this.showLeftDrawer = true,
    required this.menus,
    required this.currentUser,
    required this.child,
    required this.onChangePage,
    required this.onGetModulesMenu,
    required this.onGetInitialModule,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ResponsivePageLayout> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var getView = ifDoElse(_screenCheck, _getLargerView, _getSmallView);
    return getView(context);
  }

  _screenCheck(context) => hasEnoughWidth(context);

  _getLargerView(_) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.showLeftDrawer
            ? MenuDrawer(
                currentUser: widget.currentUser,
                onGetModulesMenu: widget.onGetModulesMenu,
                menus: widget.menus,
                current: widget.current,
                onChangePage: widget.onChangePage,
                onGetInitialModule: widget.onGetInitialModule,
              )
            : Container(),
        Expanded(child: widget.child)
      ],
    );
  }

  _getSmallView(_) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Expanded(child: widget.child),
          widget.menus.isNotEmpty
              ? FutureBuilder(
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    }
                    if (snapshot.hasData && snapshot.data != null) {
                      var menu = widget.menus
                          .where((element) => hasRbaAccess(
                              snapshot.data, element.roles, element.link))
                          .toList();
                      return AppBottomBar(
                        currentUser: widget.currentUser,
                        menus: menu,
                        onChangePage: widget.onChangePage,
                        onGetModulesMenu: widget.onGetModulesMenu,
                        onGetInitialModule: widget.onGetInitialModule,
                      );
                    }
                    return Container();
                  },
                  future: getLocalCurrentUser(),
                )
              : Container()
        ],
      ),
    );
  }
}
