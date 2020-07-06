import 'package:flutter/material.dart';
import 'modules/dashboard/dashboardView.dart';
import 'configurations.dart';

void main() => runApp(SmartStockApp());

class SmartStockApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartStock App',
      theme: ThemeData(
        primarySwatch: Config.primaryColor,
      ),
      home: Scaffold(body: DashBoardView(),
          ),
    );
  }
}

