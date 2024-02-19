import 'package:flutter/material.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/stocks/components/stock_summary.dart';

class StocksIndexPage extends PageBase {
  final OnBackPage onBackPage;
  final OnChangePage onChangePage;

  const StocksIndexPage({
    Key? key,
    required this.onChangePage,
    required this.onBackPage,
  }) : super(key: key, pageName: 'StocksIndexPage');

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<StocksIndexPage> {
  @override
  Widget build(context) {
    var appBar = SliverSmartStockAppBar(
      title: "Products summary",
      showBack: true,
      onSearch: (p0) {
        widget.onBackPage();
      },
      context: context,
    );
    return ResponsivePage(
      office: '',
      current: '/stock/',
      sliverAppBar: appBar,
      staticChildren: [
        StocksSummary(
            onBackPage: widget.onBackPage, onChangePage: widget.onChangePage)
      ],
    );
  }

// List<ModulePageMenu> _pages(BuildContext context) {
//   return [
//     ModulePageMenu(
//       name: 'Inventories',
//       link: '/stock/products',
//       roles: [],
//       icon: Icons.sale,
//       svgName: 'product_icon.svg',
//       onClick: () => widget.onChangePage(
//         ProductsPage(
//           onBackPage: widget.onBackPage,
//           onChangePage: widget.onChangePage,
//         ),
//       ),
//     ),
//     ModulePageMenu(
//       name: 'Categories',
//       link: '/stock/categories',
//       roles: [],
//       icon: Icons.category,
//       svgName: 'category_icon.svg',
//       onClick: () => widget.onChangePage(
//         CategoriesPage(
//           onBackPage: widget.onBackPage,
//           onChangePage: widget.onChangePage,
//         ),
//       ),
//     ),
//     ModulePageMenu(
//       name: 'Suppliers',
//       link: '/stock/suppliers',
//       roles: [],
//       icon: Icons.support_agent_sharp,
//       svgName: 'supplier_icon.svg',
//       onClick: () => widget.onChangePage(
//         SuppliersPage(
//           onBackPage: widget.onBackPage,
//         ),
//       ),
//     ),
//     ModulePageMenu(
//       name: 'Purchases',
//       link: '/stock/purchases',
//       roles: [],
//       icon: Icons.receipt,
//       svgName: 'invoice_icon.svg',
//       onClick: () => widget.onChangePage(
//         PurchasesPage(
//           onBackPage: widget.onBackPage,
//           onChangePage: widget.onChangePage,
//         ),
//       ),
//     ),
//     ModulePageMenu(
//       name: 'Transfer',
//       link: '/stock/transfers',
//       roles: [],
//       icon: Icons.change_circle,
//       svgName: 'transfer_icon.svg',
//       onClick: () => widget.onChangePage(
//         TransfersPage(
//           onBackPage: widget.onBackPage,
//           onChangePage: widget.onChangePage,
//         ),
//       ),
//     ),
//   ];
// }
}
