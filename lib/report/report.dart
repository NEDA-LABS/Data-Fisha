import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock/core/models/external_service.dart';
import 'package:smartstock/report/pages/category_performance.dart';
import 'package:smartstock/report/pages/overview_cash_sales.dart';
import 'package:smartstock/report/pages/overview_invoice_sales.dart';
import 'package:smartstock/report/pages/product_performance.dart';
import 'package:smartstock/report/pages/sales_cash_tracking.dart';
import 'package:smartstock/report/pages/seller_performance.dart';

class ReportModule extends Module {
  final home = ChildRoute('/', child: (_, __) => const OverviewCashSales());
  final dailyCashSales = ChildRoute('/sales/overview/cash',
      child: (_, __) => const OverviewCashSales());
  // final monthlyCashSales = ChildRoute('/sales/overview/cash/month',
  //     child: (_, __) => const MonthlyCashSales());
  // final yearlyCashSales = ChildRoute('/sales/overview/cash/year',
  //     child: (_, __) => const YearlyCashSales());
  final dailyInvoiceSales = ChildRoute('/sales/overview/invoice',
      child: (_, __) => const OverviewInvoiceSales());
  // final monthlyInvoiceSales = ChildRoute('/sales/overview/invoice/month',
  //     child: (_, __) => const MonthlyInvoiceSales());
  // final yearlyInvoiceSales = ChildRoute('/sales/overview/invoice/year',
  //     child: (_, __) => const YearlyInvoiceSales());
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
        // monthlyCashSales,
        // yearlyCashSales,
        dailyInvoiceSales,
        // monthlyInvoiceSales,
        // yearlyInvoiceSales,
        cashSaleTracking,
        productPerformance,
        categoryPerformance,
        sellerPerformance
      ];

  @override
  List<Bind> get binds => [];
}
