import 'dart:async';

import 'package:builders/builders.dart';
import 'package:flutter/material.dart';
import 'package:smartstock_pos/app.dart';
import 'package:smartstock_pos/core/components/responsive_body.dart';
import 'package:smartstock_pos/core/components/table_context_menu.dart';
import 'package:smartstock_pos/core/components/top_bar.dart';
import 'package:smartstock_pos/core/models/menu.dart';
import 'package:smartstock_pos/core/services/stocks.dart';
import 'package:smartstock_pos/core/services/util.dart';
import 'package:smartstock_pos/stocks/states/products_list_state.dart';

import '../../core/components/table_like_list.dart';
import '../states/product_loading_state.dart';

class ProductCreatePage extends StatelessWidget {
  const ProductCreatePage({Key key}) : super(key: key);


  _appBar(context) {
    return topBAr(
      title: "Create product",
      showBack: !hasEnoughWidth(context),
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
      body: ListView(
        children: [

        ],
      ),
    ),
  );
}
