import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyMedium.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/TitleLarge.dart';
import 'package:smartstock/core/components/TitleMedium.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/logo_black.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/components/surface_with_image.dart';
import 'package:smartstock/core/pages/page_base.dart';

class DashboardIndexPage extends PageBase {
  const DashboardIndexPage({super.key}) : super(pageName: 'DashboardIndexPage');

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<DashboardIndexPage> {
  @override
  Widget build(context) {
    return ResponsivePage(
      backgroundColor: Theme.of(context).colorScheme.surface,
      office: 'Menu',
      current: '/dashboard/',
      sliverAppBar: SliverSmartStockAppBar(
          title: "Dashboard", showBack: false, context: context),
      onBody: (drawer) {
        return Scaffold(
          body: SurfaceWithImage(
            child: Container(
              width: MediaQuery.of(context).size.width,
              constraints:
              BoxConstraints(minHeight: MediaQuery.of(context).size.height),
              child: ListView(
                shrinkWrap: true,
                children: [
                  _getHeader(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _getHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Row(
        children: [
          TitleMedium(text: 'CHATAFISHA'),
          WhiteSpacer(width: 16),
          LogoBlack(size: 38),
          // Expanded(child: Container()),
          // Container(
          //   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          //   decoration: BoxDecoration(
          //     borderRadius: const BorderRadius.all(Radius.circular(8)),
          //     color: Theme.of(context).colorScheme.primary,
          //   ),
          //   child: InkWell(
          //     onTap: (){},
          //     child: BodyMedium(
          //       text: 'Connect wallet',
          //       color: Theme.of(context).colorScheme.onPrimary,
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
