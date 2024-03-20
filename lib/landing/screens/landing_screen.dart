import 'package:flutter/material.dart';
import 'package:smartstock/account/components/LoginForm.dart';
import 'package:smartstock/account/pages/RegisterPage.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/BodyMedium.dart';
import 'package:smartstock/core/components/DisplayTextMedium.dart';
import 'package:smartstock/core/components/TitleLarge.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/logo_black.dart';
import 'package:smartstock/core/components/logo_white.dart';
import 'package:smartstock/core/components/surface_with_image.dart';
import 'package:smartstock/core/helpers/dialog_or_fullscreen.dart';
import 'package:smartstock/core/helpers/util.dart';

class LandingScreen extends StatelessWidget {
  final OnGeAppMenu onGetModulesMenu;
  final OnGetInitialPage onGetInitialModule;

  const LandingScreen(
      {super.key,
      required this.onGetModulesMenu,
      required this.onGetInitialModule});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SurfaceWithImage(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            padding: getIsSmallScreen(context)
                ? const EdgeInsets.all(0)
                : EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width > 1100
                        ? (MediaQuery.of(context).size.width - 1100) / 2
                        : 0),
            shrinkWrap: true,
            children: [
              _getHeader(context),
              const WhiteSpacer(height: 24),
              _getBody(context),
              const WhiteSpacer(height: 48)
            ],
          ),
        ),
      ),
    );
  }

  Widget _getHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Row(
        children: [
          LogoBlack(size: 48),
          // Expanded(child: Container()),
          // Container(
          //   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          //   decoration: BoxDecoration(
          //     borderRadius: const BorderRadius.all(Radius.circular(8)),
          //     color: Theme.of(context).colorScheme.primary,
          //   ),
          //   child: BodyMedium(
          //     text: 'Connect wallet',
          //     color: Theme.of(context).colorScheme.onPrimary,
          //   ),
          // )
        ],
      ),
    );
  }

  Widget _getBody(BuildContext context) {
    var isSmallScreen = getIsSmallScreen(context);
    return isSmallScreen
        ? _getSmallScreenView(context)
        : _getLargeScreenView(context);
  }

  Widget _getSmallScreenView(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getBodySupportActionPart(context),
          const WhiteSpacer(height: 48),
          _getBodyAccountActionPart(context)
        ],
      ),
    );
  }

  Widget _getLargeScreenView(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 1, child: _getBodySupportActionPart(context)),
          const WhiteSpacer(width: 48),
          Expanded(flex: 1, child: _getBodyAccountActionPart(context))
        ],
      ),
    );
  }

  Widget _getBodyAccountActionPart(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          // mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const DisplayTextMedium(text: 'Let\'s get\nStarted'),
            const WhiteSpacer(width: 16),
            getIsSmallScreen(context) ? Container() : const LogoBlack(size: 100)
          ],
        ),
        const BodyLarge(
            text:
                'Welcome to Chatafisha, your one step away from making real impact'),
        const WhiteSpacer(height: 16),
        InkWell(
          onTap: () => _registerAccount(context),
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xffD9E2DE)),
              height: 98,
              child: Center(
                  child: TitleLarge(
                text: 'Open an account',
                // color: ,
              ))),
        ),
        const WhiteSpacer(height: 16),
        InkWell(
          onTap: () => _signIn(context),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color(0xffD9D9D9)),
            height: 98,
            child: Center(
                child: TitleLarge(
              text: 'Already have account',
              // color: Theme.of(context).colorScheme.onPrimary,
            )),
          ),
        ),
      ],
    );
  }

  Widget _getBodySupportActionPart(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 300,
          // padding: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.primary,
            image: const DecorationImage(
              image: AssetImage("assets/images/elephant.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(child: Container()),
                    const LogoWhite(size: 48)
                  ],
                )
              ],
            ),
          ) /* add child content here */,
        ),
        const WhiteSpacer(height: 24),
        Row(
          children: [
            Expanded(
                flex: 1,
                child: InkWell(
                  onTap: _onSokoniPressed,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10)),
                    child: BodyMedium(
                      text: '\nSokoni\nMarket place',
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                )),
            const WhiteSpacer(width: 16),
            Expanded(
                flex: 1,
                child: InkWell(
                  onTap: _onTupeSupport,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(10)),
                    child: BodyMedium(
                      text: '\nTupe\nSupport',
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                )),
          ],
        )
      ],
    );
  }

  void _onSokoniPressed() {}

  void _onTupeSupport() {}

  void _signIn(BuildContext context) {
    showDialogOrFullScreenModal(
      LoginForm(
        onGetModulesMenu: onGetModulesMenu,
        onGetInitialModule: onGetInitialModule,
      ),
      context,
    );
    // Navigator.of(context).push(MaterialPageRoute(
    //   builder: (context) {
    //     return LoginPage(
    //         onGetModulesMenu: onGetModulesMenu,
    //         onGetInitialModule: onGetInitialModule);
    //   },
    // ));
  }

  void _registerAccount(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return RegisterPage(
            onGetModulesMenu: onGetModulesMenu,
            onGetInitialModule: onGetInitialModule);
      },
    ));
  }
}
