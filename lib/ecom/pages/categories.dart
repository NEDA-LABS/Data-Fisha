import 'package:flutter/material.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/components/text_input.dart';
import 'package:smartstock/core/models/SearchFilter.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/ecom/components/HeaderImage.dart';
import 'package:smartstock/ecom/components/header.dart';
import 'package:smartstock/ecom/components/menu.dart';
import 'package:smartstock/ecom/components/ribbon.dart';
import 'package:smartstock/stocks/services/category.dart';

class EComCategoriesPage extends PageBase {
  final OnBackPage onBackPage;
  final OnChangePage onChangePage;

  const EComCategoriesPage({
    super.key,
    required this.onBackPage,
    required this.onChangePage,
  }) : super(pageName: "EComCategoriesPage");

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<EComCategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const EComInfoRibbon(),
            Expanded(
              child: ResponsivePage(
                  sliverAppBar: null,
                backgroundColor: Theme.of(context).colorScheme.surface,
                staticChildren: [
                  const EComHeader(),
                  const EComHeaderImage(),
                  FutureBuilder(future: _getMenus(), builder: (context, snapshot) {
                    if(snapshot.hasData){
                      return EComContextMenu(filters: snapshot.data??_getDefaultMenus());
                    }
                    return Container();
                  },)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getDefaultMenus(){
    return [
      SearchFilter(
        name: "Discover categories",
        onClick: () {},
        selected: true,
      ),
      SearchFilter(
        name: "Popular products",
        onClick: () {},
        selected: false,
      )
    ];
  }
  Future<List<SearchFilter>> _getMenus() async {
    var categories = await getCategoryFromCacheOrRemote(skipLocal: true);
    return [
      ..._getDefaultMenus(),
      ...categories.map((e) => SearchFilter(
        name: firstLetterUpperCase("${e['name']}"),
        onClick: () {},
        selected: false,
      )).toList()
    ];
  }
}
