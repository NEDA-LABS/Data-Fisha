import 'package:flutter/material.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/bottom_bar.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/top_bar.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/report/components/date_range.dart';

class DailyCashSales extends StatelessWidget {
  const DailyCashSales({Key? key}) : super(key: key);

  @override
  Widget build(context) => responsiveBody(
        office: 'Menu',
        current: '/report/',
        menus: moduleMenus(),
        onBody: (x) => Scaffold(
          appBar: StockAppBar(
            title: "Daily cash sales",
            showBack: true,
            backLink: '/report/',
          ),
          drawer: x,
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: maximumBodyWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ReportDateRange(
                      onExport: (range) {},
                      onRange: (range) {},
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: bottomBar(1, moduleMenus(), context),
        ),
      );
}
