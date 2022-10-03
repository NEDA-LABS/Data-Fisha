import 'package:flutter_modular/flutter_modular.dart';
import 'package:smartstock/report/pages/daily_cash_sales.dart';
import 'package:smartstock/report/pages/index.dart';

class ReportModule extends Module {
  final home = ChildRoute('/', child: (_, __) => const ReportIndexPage());
  final dailyCashSales = ChildRoute('/sales/overview/cash/day',
      child: (_, __) => const DailyCashSales());
  final monthlyCashSales = ChildRoute('/sales/overview/cash/month',
      child: (_, __) => const ReportIndexPage());
  final yearlyCashSales = ChildRoute('/sales/overview/cash/year',
      child: (_, __) => const ReportIndexPage());
  final dailyInvoiceSales = ChildRoute('/sales/overview/invoice/day',
      child: (_, __) => const ReportIndexPage());
  final monthlyInvoiceSales = ChildRoute('/sales/overview/invoice/month',
      child: (_, __) => const ReportIndexPage());
  final yearlyInvoiceSales = ChildRoute('/sales/overview/invoice/year',
      child: (_, __) => const ReportIndexPage());
  final cashSaleTracking = ChildRoute('/sales/track/cash',
      child: (_, __) => const ReportIndexPage());
  final productPerformance = ChildRoute('/sales/performance/product',
      child: (_, __) => const ReportIndexPage());
  final categoryPerformance = ChildRoute('/sales/performance/category',
      child: (_, __) => const ReportIndexPage());
  final sellerPerformance = ChildRoute('/sales/performance/seller',
      child: (_, __) => const ReportIndexPage());

  @override
  List<ChildRoute> get routes => [
        home,
        dailyCashSales,
        monthlyCashSales,
        yearlyCashSales,
        dailyInvoiceSales,
        monthlyInvoiceSales,
        yearlyInvoiceSales,
        cashSaleTracking,
        productPerformance,
        categoryPerformance,
        sellerPerformance
      ];

  @override
  List<Bind> get binds => [];
}
