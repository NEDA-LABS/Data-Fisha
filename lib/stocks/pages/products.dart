import 'package:flutter/material.dart';
import 'package:smartstock_pos/app.dart';
import 'package:smartstock_pos/core/components/responsive_body.dart';
import 'package:smartstock_pos/core/components/table_context_menu.dart';
import 'package:smartstock_pos/core/components/top_bar.dart';
import 'package:smartstock_pos/core/services/util.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({Key key}) : super(key: key);

  @override
  Widget build(context) => responsiveBody(
        menus: moduleMenus(),
        current: '/stock/',
        onBody: (d) => Scaffold(
          appBar: topBAr(
              title: "Products",
              showBack: !hasEnoughWidth(context),
              backLink: '/stock/'),
          body: Column(
            children: [
              tableContextMenu(1),
            ],
          ),
        ),
      );
}
