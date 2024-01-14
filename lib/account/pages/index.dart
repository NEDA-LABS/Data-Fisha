// import 'package:flutter/material.dart';
// import 'package:smartstock/core/components/ResponsivePage.dart';
// import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
// import 'package:smartstock/core/helpers/util.dart';
// import 'package:smartstock/core/pages/page_base.dart';
//
// class ProfileIndexPage extends PageBase {
//   final OnChangePage onChangePage;
//   final OnBackPage onBackPage;
//
//   const ProfileIndexPage({
//     required this.onBackPage,
//     required this.onChangePage,
//     super.key,
//   }) : super(pageName: 'ProfileIndexPage');
//
//   @override
//   State<StatefulWidget> createState() => _State();
// }
//
// class _State extends State<ProfileIndexPage> {
//   @override
//   Widget build(context) {
//     return ResponsivePage(
//       office: 'Menu',
//       current: '/account/',
//       staticChildren: const [],
//       sliverAppBar: SliverSmartStockAppBar(
//         title: "My Account",
//         showBack: false,
//         context: context,
//       ),
//       // onBody: (x) => Scaffold(
//       //   drawer: x,
//       //   body: ,
//       //   bottomNavigationBar: bottomBar(1, moduleMenus(), context),
//       // ),
//     );
//   }
// }
