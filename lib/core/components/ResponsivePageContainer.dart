import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/AppDrawer.dart';
import 'package:smartstock/core/components/bottom_bar.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/cache_user.dart';
import 'package:smartstock/core/services/rbac.dart';
import 'package:smartstock/core/services/util.dart';

typedef ChildBuilder = Widget Function(BuildContext context, dynamic index);

class ResponsivePageContainer extends StatefulWidget {
  final String office;
  final String current;
  final bool showLeftDrawer;
  final List<ModuleMenu> menus;
  final Widget child;
  final OnChangePage onChangePage;
  final OnGetModulesMenu onGetModulesMenu;
  final OnGetInitialPage onGetInitialModule;

  const ResponsivePageContainer({
    this.office = '',
    this.current = '/',
    this.showLeftDrawer = true,
    required this.menus,
    required this.child,
    required this.onChangePage,
    required this.onGetModulesMenu,
    required this.onGetInitialModule,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ResponsivePageContainer> {
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
            ? AppDrawer(
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
    // var drawer = AppDrawer(
    //   onGetModulesMenu: widget.onGetModulesMenu,
    //   menus: widget.menus,
    //   current: widget.current,
    //   onChangePage: widget.onChangePage,
    // );
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
    // return Scaffold(
    //   // drawer: drawer,
    //   // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    //   // floatingActionButton: getIsSmallScreen(_) ? widget.fab : null,
    //   body: widget.child,
    //   bottomNavigationBar: getIsSmallScreen(context) && widget.menus.isNotEmpty
    //       ? FutureBuilder(
    //           builder: (context, snapshot) {
    //             if (snapshot.connectionState == ConnectionState.waiting) {
    //               return Container();
    //             }
    //             if (snapshot.hasData && snapshot.data != null) {
    //               var m = widget.menus
    //                   .where((element) => hasRbaAccess(
    //                       snapshot.data, element.roles, element.link))
    //                   .toList();
    //               return getBottomBar(m, context,
    //                   onChangePage: widget.onChangePage);
    //             }
    //             return Container();
    //           },
    //           future: getLocalCurrentUser(),
    //         )
    //       : null,
    // );
  }
}
