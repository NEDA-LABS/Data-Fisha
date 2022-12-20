import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/drawer.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/util.dart';

const _emptyList = <Widget>[];

Widget _emptyBuilder(_, __) => Container();

Widget _emptyBody(_) => Container();

class ResponsivePage extends StatelessWidget {
  final String office;
  final String current;
  final bool showLeftDrawer;
  final Widget? rightDrawer;
  final List<MenuModel> menus;
  final Widget? Function(Drawer? drawer) onBody;
  final SliverAppBar? sliverAppBar;
  final FloatingActionButton? fab;
  final List<Widget> staticChildren;
  final int totalDynamicChildren;
  final Widget Function(BuildContext context, dynamic index)
      dynamicChildBuilder;

  final horizontalPadding = const EdgeInsets.symmetric(horizontal: 16.0);

  const ResponsivePage({
    this.office = '',
    this.current = '/',
    this.showLeftDrawer = true,
    this.rightDrawer,
    required this.menus,
    this.onBody = _emptyBody,
    required this.sliverAppBar,
    this.staticChildren = _emptyList,
    this.totalDynamicChildren = 0,
    this.dynamicChildBuilder = _emptyBuilder,
    this.fab,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ifDoElse(
      _screenCheck, _getLargerScreenView, _getSmallScreenView)(context);

  _getBody({bottomMargin= 0}) => CustomScrollView(
        slivers: [
          sliverAppBar ?? SliverToBoxAdapter(child: Container()),
          ...staticChildren
              .map((e) => SliverToBoxAdapter(
                      child: Padding(
                    padding: horizontalPadding,
                    child: e,
                  )))
              .toList(),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: horizontalPadding,
                child: dynamicChildBuilder(context, index),
              ),
              childCount: totalDynamicChildren,
            ),
          ),
          SliverPadding(padding: EdgeInsets.only(bottom: bottomMargin))
        ],
      );

  _screenCheck(context) => hasEnoughWidth(context);

  _getLargerScreenView(_) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StockDrawer(menus, current),
          Container(width: 0.5, color: const Color(0xFFDADADA)),
          Expanded(child: Scaffold(body: _getBody(bottomMargin: 24))),
          rightDrawer ?? const SizedBox(width: 0)
        ],
      );

  _getSmallScreenView(_) => Scaffold(
      drawer: StockDrawer(menus, current),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: isSmallScreen(_)?fab:null,
      body: _getBody(bottomMargin: 100));
}
