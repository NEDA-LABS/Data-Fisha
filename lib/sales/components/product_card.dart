import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/core/services/util.dart';

Widget productCardItem({
  String productCategory,
  String productName,
  dynamic productPrice,
}) =>
    Card(
        color: Colors.white,
        // elevation: 4,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: Column(children: <Widget>[
              Expanded(
                  child: Text(productCategory ?? "Category",
                      style: const TextStyle(
                          color: Colors.grey,
                          overflow: TextOverflow.ellipsis))),
              Expanded(
                  flex: 2,
                  child: Container(
                      padding: const EdgeInsets.all(4),
                      child: Text(productName ?? "Name",
                          textAlign: TextAlign.center,
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.black)))),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                          productPrice != null
                              ? NumberFormat.currency(name: 'TZS ')
                                  .format(doubleOrZero(productPrice))
                              : "TZS 0",
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            // fontSize: 14
                          ))))
            ])));
