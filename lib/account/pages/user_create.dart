import 'package:flutter/material.dart';
import 'package:smartstock/account/services/shop_users.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/button.dart';
import 'package:smartstock/core/components/choices_input.dart';
import 'package:smartstock/core/components/info_dialog.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/text_input.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';
import 'package:smartstock/core/services/account.dart';
import 'package:smartstock/core/services/util.dart';

class ShopUserCreatePage extends StatefulWidget {
  const ShopUserCreatePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ShopUserCreatePage> {
  var state = {};
  var loading = false;
  var shops = [];

  updateState(map) {
    map is Map
        ? setState(() {
            state.addAll(map);
          })
        : null;
  }

  @override
  Widget build(context) {
    return ResponsivePage(
      current: '/account/',
      sliverAppBar: _appBar(context),
      staticChildren: [
        Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
            child: Column(children: _shopUserCreateForm()),
          ),
        )
      ],
    );
  }

  _appBar(context) {
    return getSliverSmartStockAppBar(
      title: "Add user",
      showBack: true,
      // backLink: '/account/users',
      onBack: () {
        Navigator.of(context).canPop()
            ? Navigator.of(context).pop()
            : Navigator.of(context).pushNamed('/');
      },
      showSearch: false,
      context: context,
    );
  }

  List<Widget> _shopUserCreateForm() {
    return [
      TextInput(
        onText: (d) => updateState({"username": d, 'username_e': ''}),
        label: "Username",
        error: state['username_e'] ?? '',
        initialText: state['username'] ?? '',
      ),
      TextInput(
        onText: (d) => updateState({"fullname": d, 'fullname_e': ''}),
        label: "User fullname",
        placeholder: "",
        error: state['fullname_e'] ?? '',
        initialText: '${state['fullname'] ?? ''}',
      ),
      TextInput(
        onText: (d) => updateState({"password": d, 'password_e': ''}),
        label: "Password",
        error: state['password_e'] ?? '',
        initialText: '${state['password'] ?? ''}',
      ),
      ChoicesInput(
        onText: (d) {
          updateState({"role": d, 'role_e': ''});
        },
        label: "Role",
        placeholder: 'Select',
        error: state['role_e'] ?? '',
        initialText: state['role'] ?? '',
        // getAddWidget: () => createCategoryContent(),
        onField: (x) => '${x['name']}',
        onLoad: ({skipLocal = false}) async => [
          {'name': 'manager'},
          {'name': 'user'}
        ],
      ),
      ChoicesInput(
        onText: (d) {
          // print(d);
          // print(d.runtimeType);
          shops = d;
          updateState({"shops": '', 'shops_e': ''});
        },
        label: "Shops",
        placeholder: 'Select',
        error: state['shops_e'] ?? '',
        initialText: state['shops'] ?? '',
        multiple: true,
        // getAddWidget: () => createCategoryContent(),
        onField: (x) {
          // print(x);
          return '${x['businessName']}';
        },
        onLoad: ({skipLocal = false}) async => await getUserShops(),
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
        child: raisedButton(
            height: 40,
            onPressed: loading ? null : _onPressed,
            title: loading ? "Waiting..." : "Create"),
      )
    ];
  }

  _onPressed() {
    var username = state['username'];
    var fullname = state['fullname'];
    var password = state['password'];
    var role = state['role'];
    if (!(username is String && username.isNotEmpty)) {
      updateState({'username_e': 'Username required'});
    }
    if (!(fullname is String && fullname.isNotEmpty)) {
      updateState({'fullname_e': 'Fullname required'});
    }
    if (!(password is String && password.isNotEmpty)) {
      updateState({'password_e': 'Password required'});
    }
    if (!(role is String && role.isNotEmpty)) {
      updateState({'role_e': 'Role required'});
    }
    if (!(shops is List && shops.isNotEmpty)) {
      updateState({'shops_e': 'Shops required'});
      return;
    }
    setState(() {
      loading = true;
    });
    var firstShop = shops.first;
    addShopUser({
      "username": username,
      "firstname": '$fullname'.replaceAll('.', ''),
      "lastname": ".",
      "password": password,
      "applicationId": firstShop['applicationId'],
      "projectId": firstShop['projectId'],
      "businessName": firstShop['businessName'],
      "role": role,
      "acl": [],
      "shops": shops.sublist(1)
    }).then((value) {
      // print(value);
      navigateTo('/account/users');
    }).catchError((onError) {
      showInfoDialog(context, '$onError}', title: "Error!");
    }).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }
}
