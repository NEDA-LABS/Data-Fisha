import 'package:flutter/material.dart';
import 'package:smartstock_pos/app.dart';
import 'package:smartstock_pos/core/components/responsive_body.dart';
import 'package:smartstock_pos/core/components/text_input.dart';
import 'package:smartstock_pos/core/components/top_bar.dart';
import 'package:smartstock_pos/core/services/util.dart';

class ProductCreatePage extends StatelessWidget {
  const ProductCreatePage({Key key}) : super(key: key);

  _appBar(context) {
    return topBAr(
      title: "Create product",
      showBack: true, //!hasEnoughWidth(context),
      backLink: '/stock/products',
      showSearch: false,
    );
  }

  @override
  Widget build(context) => responsiveBody(
        menus: moduleMenus(),
        current: '/stock/',
        onBody: (d) => Scaffold(
          appBar: _appBar(context),
          body: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
              child: ListView(
                children: [
                  textInput(
                      onText: (d) {},
                      label: 'Name',
                      placeholder: 'Brand + Generic name'),
                ],
              ),
            ),
          ),
        ),
      );
}
