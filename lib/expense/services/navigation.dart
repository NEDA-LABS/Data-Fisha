import 'package:flutter/material.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/expense/pages/expenses.dart';
import 'package:smartstock/expense/pages/index.dart';

MenuModel expenseMenu(BuildContext context) => MenuModel(
      name: 'Expenses',
      icon: const Icon(Icons.receipt_long_rounded),
      link: '/expense/',
      // onClick: () {
      //   Navigator.of(context).pushAndRemoveUntil(
      //       MaterialPageRoute(
      //           builder: (context) => ExpenseExpensesPage(onGetModulesMenu: ),
      //           settings: const RouteSettings(name: 'r_expense')),
      //       (route) => route.settings.name != 'r_expense');
      // },
      roles: ['*'],
    );
