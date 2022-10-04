import 'package:builders/builders.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/button.dart';
import 'package:smartstock/core/components/choices_input.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/text_input.dart';
import 'package:smartstock/core/components/top_bar.dart';
import 'package:smartstock/stocks/components/product_create_form.dart';
import 'package:smartstock/stocks/states/product_create.dart';

class ShopUserCreatePage extends StatefulWidget {
  const ShopUserCreatePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ShopUserCreatePage> {
  var state = {};
  var loading = false;

  updateState(map) {
    map is Map
        ? setState(() {
            state.addAll(map);
          })
        : null;
  }

  @override
  Widget build(context) {
    return responsiveBody(
      menus: moduleMenus(),
      current: '/account/',
      onBody: (d) {
        return Scaffold(
          appBar: _appBar(context),
          body: SingleChildScrollView(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                child: Column(children: _shopUserCreateForm()),
              ),
            ),
          ),
        );
      },
    );
  }

  _appBar(context) {
    return StockAppBar(
      title: "Add user",
      showBack: true,
      backLink: '/account/users',
      showSearch: false,
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
          updateState({"role": d});

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
          updateState({"shops": d, 'shops_e': ''});

        },
        label: "Shops",
        placeholder: 'Select',
        error: state['shops_e'] ?? '',
        initialText: state['shops'] ?? '',
        // getAddWidget: () => createCategoryContent(),
        onField: (x) => '${x['name']}',
        onLoad: ({skipLocal = false})async => [],
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
        child: raisedButton(
            onPressed: loading ? null : _onPressed,
            title: loading ? "Waiting..." : "Create"),
      )
    ];
  }

  _onPressed() {}
}
