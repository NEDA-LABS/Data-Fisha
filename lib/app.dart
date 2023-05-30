import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock/account/pages/LoginPage.dart';
import 'package:smartstock/core/components/ResponsivePageContainer.dart';
import 'package:smartstock/core/services/cache_user.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/dashboard/pages/index.dart';
import 'package:smartstock/sales/pages/index.dart';

class SmartStockCoreModule extends Module {
  final OnGetModulesMenu onGetModulesMenu;
  final Map<String, Module Function(OnGetModulesMenu)> coreModules;

  SmartStockCoreModule(
      {required this.onGetModulesMenu, required this.coreModules})
      : super();

  @override
  List<ModularRoute> get routes => coreModules.keys
      .map((e) => ModuleRoute(e, module: coreModules[e]!(onGetModulesMenu)))
      .toList();

  @override
  List<Bind> get binds => [];
}

class SmartStockApp extends StatefulWidget {
  final OnGetModulesMenu onGetModulesMenu;

  const SmartStockApp({Key? key, required this.onGetModulesMenu})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SmartStockApp> {
  Widget? child = const DashboardIndexPage();
  Widget? rightDrawer;
  List<Widget> pageHistories = [];
  bool loading = false;
  bool initialized = false;
  Map? user;

  @override
  void initState() {
    _getLoginUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (loading == true) {
      return Container();
    }
    if (user is Map && propertyOrNull('username')(user) != null) {
      return ResponsivePageContainer(
        menus: widget.onGetModulesMenu(
          context: context,
          onChangePage: _onChangePage,
          onBackPage: _onBackPage,
          onChangeRightDrawer: _onChangeRightDrawer,
        ),
        onChangePage: _onChangePage,
        rightDrawer: rightDrawer,
        child: child ?? Container(),
      );
    } else {
      return LoginPage(
        onDoneSelectShop: (Map data) {
          _updateState(() {
            user = data;
          });
        },
      );
    }
  }

  _onChangePage(page) {
    _updateState(() {
      child = page;
      pageHistories.add(page);
    });
  }

  _onBackPage() {
    // print(pageHistories);
    var length = pageHistories.length;
    if (length > 0) {
      var last = pageHistories[length - 2];
      if (last != null) {
        _updateState(() {
          child = last;
          pageHistories.removeAt(length - 1);
        });
      }
    }
    // print(pageHistories);
  }

  _updateState(Function() fn) {
    if (mounted) {
      setState(fn);
    }
  }

  _getLoginUser() {
    _updateState(() {
      loading = true;
      user = null;
      initialized = false;
    });
    getLocalCurrentUser().then((value) {
      user = value is Map && value['username'] != null ? value : null;
      if (user == null) {
        return;
      }
      var role = propertyOrNull('role')(user);
      if (role != 'admin' && initialized == false) {
        child = SalesPage(
          onChangePage: _onChangePage,
          onBackPage: _onBackPage,
          onChangeRightDrawer: _onChangeRightDrawer,
        );
      }
      initialized = true;
    }).catchError((err) {
      if (kDebugMode) {
        print(err);
      }
      user = null;
    }).whenComplete(() {
      _updateState(() {
        loading = false;
      });
    });
  }

  _onChangeRightDrawer(drawer) {
    _updateState(() {
      rightDrawer = drawer;
    });
  }
}
