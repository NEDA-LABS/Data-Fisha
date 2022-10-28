import 'package:flutter/material.dart';
import 'package:smartstock/app_start.dart';
import 'package:smartstock/core/models/external_service.dart';

void main() {
  startSmartStock(
    externalSaleServices: [
      ExternalService(
          name: 'Kata tiketi',
          icon: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onBuild: (context, args) {
            return const Scaffold(
              body: Text('Test External'),
            );
          },
          pageLink: '/tiketi')
    ],
  );
}
