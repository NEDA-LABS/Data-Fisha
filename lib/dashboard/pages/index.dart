import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/CardRoot.dart';
import 'package:smartstock/core/components/DisplayTextMedium.dart';
import 'package:smartstock/core/components/DisplayTextSmall.dart';
import 'package:smartstock/core/components/PrimaryAction.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/TitleLarge.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/info_dialog.dart';
import 'package:smartstock/core/components/logo_black.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/components/surface_with_image.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/dashboard/services/dashboard.dart';
import 'package:smartstock/stocks/pages/purchase_create_page.dart';
import 'package:smartstock/stocks/services/supplier.dart';

class DashboardIndexPage extends PageBase {
  final OnChangePage onChangePage;
  final OnBackPage onBackPage;

  const DashboardIndexPage(
      {super.key, required this.onChangePage, required this.onBackPage})
      : super(pageName: 'DashboardIndexPage');

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<DashboardIndexPage> {
  bool _loading = false;
  List _pickers = [];
  var _collected = 0;

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
                  _getTitleAndActions(context),
                  const WhiteSpacer(height: 16),
                  _loading
                      ? Container(
                          padding: const EdgeInsets.all(24),
                          child:
                              const Center(child: CircularProgressIndicator()),
                        )
                      : _getPickers(context, isSmallScreen),
                  const WhiteSpacer(height: 24)
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
          TitleLarge(text: 'CHATAFISHA'),
          WhiteSpacer(width: 16),
          LogoBlack(size: 38),
        ],
      ),
    );
  }

  Widget _getTitleAndActions(BuildContext context) {
    var isSmallScreen = getIsSmallScreen(context);
    var largeScreenView = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Wrap(children: [
            const DisplayTextSmall(text: 'Welcome to Chatafisha,'),
            const WhiteSpacer(width: 8),
            const DisplayTextSmall(text: 'we create'),
            const WhiteSpacer(width: 8),
            DisplayTextSmall(
                text: 'real + impact ',
                color: Theme.of(context).colorScheme.primary),
          ]),
        ),
        const WhiteSpacer(width: 16),
        // Expanded(child: Container()),
        PrimaryAction(
            text: 'Offset-data',
            onPressed: () {
              widget.onChangePage(
                  PurchaseCreatePage(onBackPage: widget.onBackPage));
            },
            color: const Color(0xffFA5A23),
            leading: const Icon(Icons.arrow_forward))
      ],
    );
    var smallScreenView = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Wrap(children: [
                const DisplayTextSmall(text: 'Welcome to Chatafisha,'),
                const WhiteSpacer(width: 8),
                const DisplayTextSmall(text: 'we create'),
                const WhiteSpacer(width: 8),
                DisplayTextSmall(
                    text: 'real + impact ',
                    color: Theme.of(context).colorScheme.primary),
              ]),
            )
          ],
        ),
        const WhiteSpacer(height: 16),
        PrimaryAction(
            text: 'Offset-data',
            onPressed: () {
              widget.onChangePage(
                  PurchaseCreatePage(onBackPage: widget.onBackPage));
            },
            color: const Color(0xffFA5A23),
            leading: const Icon(Icons.arrow_forward))
      ],
    );
    return isSmallScreen ? smallScreenView : largeScreenView;
  }

  Widget _getPickers(BuildContext context, bool isSmallScreen) {
    var isSmallScreen = getIsSmallScreen(context);
    var largeView = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TitleLarge(text: 'Total waste collected'),
            const WhiteSpacer(height: 8),
            DisplayTextMedium(text: '${formatNumber(_collected,decimals: 2)} Kg'),
            const WhiteSpacer(height: 8),
            Container(
              // height: 24,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                  color: const Color(0xffFA5A23),
                  borderRadius: BorderRadius.circular(20)),
              child: const BodyLarge(text: 'Offset', color: Colors.white),
            )
          ],
        ),
        const WhiteSpacer(width: 16),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const TitleLarge(text: 'Number of waste pickers'),
              const WhiteSpacer(width: 8),
              DisplayTextMedium(text: '${_pickers.length}'),
            ],
          ),
        ),
        const WhiteSpacer(width: 16),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20)),
              child: TitleLarge(
                  text: 'Carbon credit',
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
            ),
            const WhiteSpacer(height: 8),
            DisplayTextMedium(text: '${formatNumber(doubleOrZero(_collected)/1000,decimals: 3)} Cc'),
            const WhiteSpacer(height: 8),
            const BodyLarge(
                text: 'Impact calculator', color: Color(0xffFA5A23)),
            const BodyLarge(text: 'www.chatafisha.com'),
          ],
        )
      ],
    );
    var smallView = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Column(
        //   mainAxisSize: MainAxisSize.min,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        const TitleLarge(text: 'Total waste collected'),
        const WhiteSpacer(height: 8),
        DisplayTextMedium(text: '${formatNumber(_collected,decimals: 2)} Kg'),
        // const WhiteSpacer(height: 8),
        // Container(
        //   // height: 24,
        //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        //   decoration: BoxDecoration(
        //       color: const Color(0xffFA5A23),
        //       borderRadius: BorderRadius.circular(20)),
        //   child: const BodyLarge(text: 'Offset', color: Colors.white),
        // ),
        // ],
        // ),
        const WhiteSpacer(height: 16),
        // Expanded(
        //   child: Column(
        //     mainAxisSize: MainAxisSize.min,
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: [
        const TitleLarge(text: 'Number of waste pickers'),
        const WhiteSpacer(width: 8),
        DisplayTextMedium(text: '${_pickers.length}'),
        // ],
        // ),
        // ),
        const WhiteSpacer(height: 16),
        // Column(
        //   mainAxisSize: MainAxisSize.min,
        //   crossAxisAlignment: CrossAxisAlignment.end,
        //   children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20)),
          child: TitleLarge(
              text: 'Carbon credit',
              color: Theme.of(context).colorScheme.onPrimaryContainer),
        ),
        const WhiteSpacer(height: 8),
        DisplayTextMedium(text: '${formatNumber(doubleOrZero(_collected)/1000,decimals: 3)} Cc'),
        const WhiteSpacer(height: 8),
        const BodyLarge(text: 'Impact calculator', color: Color(0xffFA5A23)),
        const BodyLarge(text: 'www.chatafisha.com'),
        // ],
        // )
      ],
    );
    return CardRoot(
        child: Container(
      padding: const EdgeInsets.all(16),
      child: isSmallScreen ? smallView : largeView,
    ));
  }

  void _fetPickers() {
    setState(() {
      _loading = true;
    });
    getCenterDashboardData(DateTime.now()).then((value) {
      setState(() {
        _collected = doubleOrZero(value is Map?(value['sum']):0);
      });
      return getSupplierFromCacheOrRemote(true);
    }).then((value) {
      setState(() {
        _pickers = itOrEmptyArray(value);
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
