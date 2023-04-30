import 'package:bfast/util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/StockDrawer.dart';
import 'package:smartstock/core/components/bottom_bar.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/util.dart';

const _emptyList = <Widget>[];

Widget _emptyBuilder(_, __) => Container();

typedef ChildBuilder = Widget Function(BuildContext context, dynamic index);

class ResponsivePage extends StatefulWidget {
  final String office;
  final String current;
  final bool showLeftDrawer;
  final Widget? rightDrawer;
  final List<MenuModel> menus;
  final Widget Function(Drawer? drawer)? onBody;
  final SliverAppBar? sliverAppBar;
  final FloatingActionButton? fab;
  final List<Widget> staticChildren;
  final int totalDynamicChildren;
  final ChildBuilder dynamicChildBuilder;
  final bool loading;
  final Future Function()? onLoadMore;

  // final double currentBottomNavItemIndex;

  final EdgeInsets horizontalPadding;

  const ResponsivePage({
    this.office = '',
    this.current = '/',
    this.showLeftDrawer = true,
    this.rightDrawer,
    required this.menus,
    this.onBody,
    required this.sliverAppBar,
    this.staticChildren = _emptyList,
    this.totalDynamicChildren = 0,
    this.dynamicChildBuilder = _emptyBuilder,
    this.fab,
    this.loading = false,
    this.onLoadMore,
    this.horizontalPadding = const EdgeInsets.symmetric(horizontal: 16.0),
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ResponsivePage> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    _controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var getView =
        ifDoElse(_screenCheck, _getLargerScreenView, _getSmallScreenView);
    return getView(context);
  }

  _customScrollView(bottomMargin) => CustomScrollView(
        controller: _controller,
        slivers: [
          widget.sliverAppBar ?? SliverToBoxAdapter(child: Container()),
          ...widget.staticChildren
              .map((e) => SliverToBoxAdapter(
                      child: Padding(
                    padding: widget.horizontalPadding,
                    child: e,
                  )))
              .toList(),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: widget.horizontalPadding,
                child: widget.dynamicChildBuilder(context, index),
              ),
              childCount: widget.totalDynamicChildren,
            ),
          ),
          widget.loading && widget.totalDynamicChildren > 0
              ? const SliverToBoxAdapter(
                  child: SizedBox(
                      height: 60,
                      child: Center(child: CircularProgressIndicator())))
              : const SliverToBoxAdapter(),
          SliverPadding(
              padding: EdgeInsets.only(bottom: doubleOrZero(bottomMargin)))
        ],
      );

  _scrollListener() {
    if (_controller.position.extentAfter < 50) {
      _loadMore();
    }
  }

  _loadMore() {
    if (widget.loading == true) {
      if (kDebugMode) {
        print('STILL LOADING....');
      }
      return;
    }
    if (widget.onLoadMore != null) {
      if (kDebugMode) {
        print('LOAD MORE.');
      }
      widget.onLoadMore!();
    }
  }

  _screenCheck(context) => hasEnoughWidth(context);

  _getLargerScreenView(_) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.showLeftDrawer
              ? StockDrawer(widget.menus, widget.current)
              : Container(),
          Expanded(
              child: widget.onBody != null
                  ? widget.onBody!(null)
                  : Scaffold(body: _customScrollView(24))),
          widget.rightDrawer ?? const SizedBox(width: 0)
        ],
      );

  _getSmallScreenView(_) {
    var drawer = StockDrawer(widget.menus, widget.current);
    var scaffold = Scaffold(
      drawer: drawer,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: getIsSmallScreen(_) ? widget.fab : null,
      body: _customScrollView(100),
      bottomNavigationBar: getBottomBar(widget.menus, context),
    );
    var view = widget.onBody != null
        ? widget.onBody!(StockDrawer(widget.menus, widget.current))
        : scaffold;
    return view;
  }
}
