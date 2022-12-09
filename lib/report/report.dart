import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock/core/models/external_service.dart';
import 'package:smartstock/report/pages/sales_category_performance.dart';
import 'package:smartstock/report/pages/sales_cash_overview.dart';
import 'package:smartstock/report/pages/sales_invoice_overview.dart';
import 'package:smartstock/report/pages/sales_product_performance.dart';
import 'package:smartstock/report/pages/sales_cash_tracking.dart';
import 'package:smartstock/report/pages/sales_seller_performance.dart';

class ReportModule extends Module {
  final home = ChildRoute('/', child: (_, __) => const OverviewCashSales());
  final dailyCashSales = ChildRoute('/sales/overview/cash',
      child: (_, __) => const OverviewCashSales());
  final dailyInvoiceSales = ChildRoute('/sales/overview/invoice',
      child: (_, __) => const OverviewInvoiceSales());
  final cashSaleTracking = ChildRoute('/sales/track/cash',
      child: (_, __) => const SalesCashTrackingPage());
  final productPerformance = ChildRoute('/sales/performance/product',
      child: (_, __) => const ProductPerformance());
  final categoryPerformance = ChildRoute('/sales/performance/category',
      child: (_, __) => const CategoryPerformance());
  final sellerPerformance = ChildRoute('/sales/performance/seller',
      child: (_, __) => const SellerPerformance());

  ReportModule(List<ExternalService> services);

  @override
  List<ChildRoute> get routes => [
        home,
        dailyCashSales,
        dailyInvoiceSales,
        cashSaleTracking,
        productPerformance,
        categoryPerformance,
        sellerPerformance
      ];

  @override
  List<Bind> get binds => [];
}
