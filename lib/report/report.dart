// import 'package:flutter_modular/flutter_modular.dart';
// import 'package:smartstock/core/guards/auth.dart';
// import 'package:smartstock/core/guards/owner.dart';
// import 'package:smartstock/core/services/util.dart';
// import 'package:smartstock/report/pages/sales_cash_overview.dart';
// import 'package:smartstock/report/pages/sales_cash_tracking.dart';
// import 'package:smartstock/report/pages/sales_category_performance.dart';
// import 'package:smartstock/report/pages/sales_invoice_overview.dart';
// import 'package:smartstock/report/pages/sales_product_performance.dart';
// import 'package:smartstock/report/pages/sales_seller_performance.dart';
// import 'package:smartstock/sales/guards/active_shop.dart';
//
// class ReportModule extends Module {
//   final OnGetModulesMenu onGetModulesMenu;
//
//   ReportModule({required this.onGetModulesMenu}) : super();
//
//   @override
//   List<ChildRoute> get routes => [
//         ChildRoute(
//           '/',
//           guards: [AuthGuard(), ActiveShopGuard(), OwnerGuard()],
//           child: (_, __) => ReportIndexPage(),
//         ),
//         ChildRoute('/sales/overview/cash',
//             guards: [AuthGuard(), ActiveShopGuard(), OwnerGuard()],
//             child: (_, __) => OverviewCashSales()),
//         ChildRoute('/sales/overview/invoice',
//             guards: [AuthGuard(), ActiveShopGuard(), OwnerGuard()],
//             child: (_, __) => OverviewInvoiceSales()),
//         ChildRoute('/sales/track/cash',
//             guards: [AuthGuard(), ActiveShopGuard(), OwnerGuard()],
//             child: (_, __) => SalesCashTrackingPage()),
//         ChildRoute(
//           '/sales/performance/product',
//           guards: [AuthGuard(), ActiveShopGuard(), OwnerGuard()],
//           child: (_, __) => ProductPerformance(),
//         ),
//         ChildRoute('/sales/performance/category',
//             guards: [AuthGuard(), ActiveShopGuard(), OwnerGuard()],
//             child: (_, __) => CategoryPerformance()),
//         ChildRoute('/sales/performance/seller',
//             guards: [AuthGuard(), ActiveShopGuard(), OwnerGuard()],
//             child: (_, __) => SellerPerformance())
//       ];
//
//   @override
//   List<Bind> get binds => [];
// }
