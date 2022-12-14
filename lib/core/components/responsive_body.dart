import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/drawer.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/util.dart';

class ResponsivePage extends StatelessWidget {
  final String office;
  final String current;
  final bool showLeftDrawer;
  final Widget? rightDrawer;
  final List<MenuModel> menus;
  final Widget? Function(Drawer? drawer) onBody;
  final SliverAppBar? sliverAppBar;

  const ResponsivePage({
    this.office = '',
    this.current = '/',
    this.showLeftDrawer = true,
    this.rightDrawer,
    required this.menus,
    required this.onBody,
    required this.sliverAppBar,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final getDrawerView = ifDoElse((f) => f == true,
        (_) => StockDrawer(menus, current), (_) => const SizedBox());
    final getVLView = ifDoElse(
        (f) => f == true,
        (_) => Container(width: 0.5, color: const Color(0xFFDADADA)),
        (_) => const SizedBox());
    var paneOrPlaneBody = ifDoElse(
      (context) => hasEnoughWidth(context),
      (_) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getDrawerView(showLeftDrawer),
          getVLView(showLeftDrawer),
          Expanded(
            child: CustomScrollView(
              slivers: [
                sliverAppBar ?? SliverToBoxAdapter(child: Container()),
                SliverToBoxAdapter(child: onBody(null) ?? Container())
              ],
            ),
          ),
          // Container(width: 0.5,color: Color(0xFFDADADA),),
          rightDrawer ?? const SizedBox(width: 0)
        ],
      ),
      (_) => CustomScrollView(
        slivers: [
          sliverAppBar ?? SliverToBoxAdapter(child: Container()),
          SliverToBoxAdapter(
              child: onBody(StockDrawer(menus, current)) ?? Container())
        ],
      ),
    );
    return paneOrPlaneBody(context);
  }
}
