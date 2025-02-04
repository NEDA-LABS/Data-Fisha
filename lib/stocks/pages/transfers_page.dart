// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:smartstock/core/components/BodyLarge.dart';
// import 'package:smartstock/core/components/LabelMedium.dart';
// import 'package:smartstock/core/components/ResponsivePage.dart';
// import 'package:smartstock/core/components/horizontal_line.dart';
// import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
// import 'package:smartstock/core/components/table_context_menu.dart';
// import 'package:smartstock/core/components/table_like_list_data_cell.dart';
// import 'package:smartstock/core/components/table_like_list_row.dart';
// import 'package:smartstock/core/helpers/dialog_or_bottom_sheet.dart';
// import 'package:smartstock/core/helpers/util.dart';
// import 'package:smartstock/core/models/menu.dart';
// import 'package:smartstock/core/pages/page_base.dart';
// import 'package:smartstock/core/services/date.dart';
// import 'package:smartstock/stocks/components/transfer_details.dart';
// import 'package:smartstock/stocks/pages/transfer_receive.dart';
// import 'package:smartstock/stocks/pages/transfer_send.dart';
// import 'package:smartstock/stocks/services/transfer.dart';
//
// class TransfersPage extends PageBase {
//   final OnChangePage onChangePage;
//   final OnBackPage onBackPage;
//
//   const TransfersPage({
//     super.key,
//     required this.onBackPage,
//     required this.onChangePage,
//   }) : super(pageName: 'TransfersPage');
//
//   @override
//   State<StatefulWidget> createState() => _TransfersPage();
// }
//
// class _TransfersPage extends State<TransfersPage> {
//   bool _loading = false;
//   final String _date = toSqlDate(DateTime.now());
//   List _transfers = [];
//
//   _appBar(context) => SliverSmartStockAppBar(
//         title: "Transfers",
//         showBack: true,
//         backLink: '/stock/',
//         showSearch: false,
//         onBack: widget.onBackPage,
//         context: context,
//       );
//
//   _contextTransfers(context) => [
//         ContextMenu(
//           name: 'Send',
//           pressed: () {
//             // navigateTo('/stock/transfers/send');
//             widget.onChangePage(
//               TransferSendPage(
//                 onBackPage: widget.onBackPage,
//               ),
//             );
//           },
//         ),
//         ContextMenu(
//           name: 'Receive',
//           pressed: () {
//             // navigateTo('/stock/transfers/receive')
//             widget.onChangePage(
//               TransferReceivePage(
//                 onBackPage: widget.onBackPage,
//               ),
//             );
//           },
//         ),
//         ContextMenu(name: 'Reload', pressed: () => _refresh(skip: true))
//       ];
//
//   _tableHeader() {
//     return const SizedBox(
//       // height: 38,
//       child: TableLikeListRow([
//         LabelMedium(text: 'DATE'),
//         LabelMedium(text: 'TYPE'),
//         LabelMedium(text: 'AMOUNT')
//       ]),
//     );
//   }
//
//   _loadingView(bool show) =>
//       show ? const LinearProgressIndicator(minHeight: 4) : Container();
//
//   @override
//   void initState() {
//     _refresh();
//     super.initState();
//   }
//
//   @override
//   Widget build(context) => ResponsivePage(
//         current: '/stock/',
//         sliverAppBar: _appBar(context),
//         backgroundColor: Theme.of(context).colorScheme.surface,
//         loading: _loading,
//         onLoadMore: () async => _loadMore(),
//         staticChildren: [
//           getTableContextMenu(_contextTransfers(context)),
//           _loadingView(_loading),
//           getIsSmallScreen(context) ? const SizedBox() : _tableHeader(),
//         ],
//         totalDynamicChildren: _transfers.length,
//         dynamicChildBuilder:
//             getIsSmallScreen(context) ? _smallScreenView : _largerScreenView,
//         fab: FloatingActionButton(
//           onPressed: () => _showMobileContextMenu(context),
//           child: const Icon(Icons.unfold_more_outlined),
//         ),
//       );
//
//   _refresh({skip = false}) {
//     setState(() {
//       _loading = true;
//     });
//     transfersGetRemote(_date).then((value) {
//       _transfers = value;
//     }).whenComplete(() {
//       setState(() {
//         _loading = false;
//       });
//     });
//   }
//
//   _renderDateCell(b, other) {
//     var f = DateFormat('yyyy-MM-dd HH:mm');
//     var date = f.format(DateTime.parse(b));
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 3),
//             child: BodyLarge(text: date),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 3.0),
//             child: LabelMedium(text: 'Shop:  $other'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showMobileContextMenu(context) {
//     showDialogOrModalSheet(
//         Container(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.call_made_outlined),
//                 title: const BodyLarge(text: 'Send'),
//                 onTap: () {
//                   widget.onChangePage(
//                     TransferSendPage(
//                       onBackPage: widget.onBackPage,
//                     ),
//                   );
//                   Navigator.of(context).maybePop();
//                 },
//               ),
//               const HorizontalLine(),
//               ListTile(
//                 leading: const Icon(Icons.call_received),
//                 title: const BodyLarge(text: 'Receive'),
//                 onTap: () {
//                   widget.onChangePage(
//                     TransferReceivePage(
//                       onBackPage: widget.onBackPage,
//                     ),
//                   );
//                   Navigator.of(context).maybePop();
//                 },
//               ),
//               const HorizontalLine(),
//               ListTile(
//                 leading: const Icon(Icons.refresh),
//                 title: const BodyLarge(text: 'Reload transfers'),
//                 onTap: () {
//                   _refresh();
//                   Navigator.of(context).maybePop();
//                 },
//               ),
//             ],
//           ),
//         ),
//         context);
//   }
//
//   _loadMore() {
//     if (_transfers.isNotEmpty) {
//       var last = _transfers.last;
//       setState(() {
//         _loading = true;
//       });
//       var updatedAt = last['updatedAt'] ?? toSqlDate(DateTime.now());
//       transfersGetRemote(updatedAt).then((value) {
//         _transfers.addAll(value);
//       }).whenComplete(() {
//         setState(() {
//           _loading = false;
//         });
//       });
//     }
//   }
//
//   Widget _largerScreenView(context, index) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         InkWell(
//           onTap: () {
//             showDialogOrModalSheet(
//                 transferDetails(context, _transfers[index]), context);
//           },
//           child: TableLikeListRow([
//             _renderDateCell(
//                 _transfers[index]['date'], _transfers[index]['otherShop']),
//             TableLikeListTextDataCell('${_transfers[index]['type']}'),
//             TableLikeListTextDataCell(
//                 '${formatNumber(_transfers[index]['amount'])}'),
//             // Center(child: _getStatusView(_purchases[index]))
//           ]),
//         ),
//         const HorizontalLine()
//       ],
//     );
//   }
//
//   Widget _smallScreenView(context, index) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         ListTile(
//           onTap: () => showDialogOrModalSheet(
//               transferDetails(context, _transfers[index]), context),
//           contentPadding: const EdgeInsets.symmetric(horizontal: 2),
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               TableLikeListTextDataCell(
//                   '${toSqlDate(DateTime.tryParse(_transfers[index]['date']) ?? DateTime.now())}'),
//               BodyLarge(text: '${compactNumber(_transfers[index]['amount'])}')
//             ],
//           ),
//           subtitle: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               LabelMedium(
//                 text: '${_transfers[index]['otherShop']}',
//               ),
//               LabelMedium(text: '${_transfers[index]['type']}')
//             ],
//           ),
//         ),
//         const SizedBox(height: 5),
//         const HorizontalLine(),
//       ],
//     );
//   }
// }
