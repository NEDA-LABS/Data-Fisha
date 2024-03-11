import 'package:flutter/material.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/TitleLarge.dart';
import 'package:smartstock/core/components/TitleMedium.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/info_dialog.dart';
import 'package:smartstock/core/components/logo_black.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/components/surface_with_image.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/dashboard/components/picker_stats.dart';
import 'package:smartstock/stocks/services/supplier.dart';

class DashboardIndexPage extends PageBase {
  const DashboardIndexPage({super.key}) : super(pageName: 'DashboardIndexPage');

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<DashboardIndexPage> {
  bool _loading = false;
  List _pickers = [];

  @override
  void initState() {
    _fetPickers();
    super.initState();
  }

  @override
  Widget build(context) {
    var isSmallScreen = getIsSmallScreen(context);
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
                padding: const EdgeInsets.all(24),
                children: [
                  _getHeader(context),
                  _getTitleAndDates(context),
                  const WhiteSpacer(height: 16),
                  _loading
                      ? Container(
                          padding: const EdgeInsets.all(24),
                          child:
                              const Center(child: CircularProgressIndicator()),
                        )
                      : _getPickers(context, isSmallScreen),
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
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: const Row(
        children: [
          TitleMedium(text: 'CHATAFISHA'),
          WhiteSpacer(width: 16),
          LogoBlack(size: 38),
        ],
      ),
    );
  }

  Widget _getTitleAndDates(BuildContext context) {
    return Wrap(
      children: [
        const TitleLarge(text: 'Your center'),
        const WhiteSpacer(width: 8),
        TitleLarge(
            text: 'verified', color: Theme.of(context).colorScheme.primary),
        const WhiteSpacer(width: 8),
        const TitleLarge(text: 'plastic collectors'),
      ],
    );
  }

  Widget _getPickers(BuildContext context, bool isSmallScreen) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          runSpacing: 16,
          spacing: 16,
          children: _pickers.map((e) {
            return SizedBox(
              width: isSmallScreen
                  ? constraints.maxWidth
                  : ((constraints.maxWidth / 2)-16),
              child: PickerStats(picker: e),
            );
          }).toList(),
        );
      },
    );
  }

  void _fetPickers() {
    setState(() {
      _loading = true;
    });
    getSupplierFromCacheOrRemote(true).then((value) {
      if (itOrEmptyArray(value).isEmpty) {
        return;
      }
      setState(() {
        _pickers = value;
      });
    }).catchError((error) {
      showTransactionCompleteDialog(context, error,
          canDismiss: true, title: 'Error');
    }).whenComplete(() {
      setState(() {
        _loading = false;
      });
    });
  }
}
