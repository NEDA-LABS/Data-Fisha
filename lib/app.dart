import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/account/pages/LoginPage.dart';
import 'package:smartstock/core/components/ResponsivePageContainer.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/cache_user.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/dashboard/pages/index.dart';
import 'package:smartstock/sales/pages/index.dart';

class SmartStockApp extends StatefulWidget {
  final OnGetModulesMenu onGetModulesMenu;

  const SmartStockApp({
    Key? key,
    required this.onGetModulesMenu,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SmartStockApp> {
  int i = 0;
  Widget? child = const DashboardIndexPage();
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
      return WillPopScope(
        child: ResponsivePageContainer(
          onGetModulesMenu: widget.onGetModulesMenu,
          menus: widget.onGetModulesMenu(
            context: context,
            onChangePage: _onChangePage,
            onBackPage: _onBackPage,
          ),
          onChangePage: _onChangePage,
          child: child ?? Container(),
        ),
        onWillPop: () async {
          if (kDebugMode) {
            print('------');
            print('Back pressed');
            print('------');
          }
          if (pageHistories.length == 1) {
            return true;
          }
          _onBackPage();
          return false;
        },
      );
    } else {
      return LoginPage(onGetModulesMenu: widget.onGetModulesMenu);
    }
  }

  _onChangePage(page) {
    _updateState(() {
      child = page;
      if (pageHistories.isNotEmpty) {
        var lastWidget = pageHistories.last;
        if ('$lastWidget' == '$page') {
          if (kDebugMode) {
            print('---- SAME PAGE ----');
          }
        } else {
          pageHistories.add(page);
        }
      } else {
        pageHistories.add(page);
      }
    });
  }

  _onBackPage() {
    var length = pageHistories.length;
    if (kDebugMode) {
      print('Length ---> $length');
    }
    goBack(int offset) {
      var last = pageHistories[length - offset];
      if (last != null) {
        _updateState(() {
          child = last;
          pageHistories.removeAt(length - 1);
        });
      }
    }

    if (length == 1) {
      goBack(1);
    }
    if (length > 1) {
      goBack(2);
    }
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
    getLocalCurrentUser().then((value) async {
      var shop = await getActiveShop();
      if (shop == null) {
        return;
      }
      user = value is Map && value['username'] != null ? value : null;
      if (user == null) {
        return;
      }
      var role = propertyOrNull('role')(user);
      if (role != 'admin' && initialized == false) {
        child = SalesPage(
          onChangePage: _onChangePage,
          onBackPage: _onBackPage,
        );
      }
      if (child != null) {
        pageHistories.add(child!);
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
}
