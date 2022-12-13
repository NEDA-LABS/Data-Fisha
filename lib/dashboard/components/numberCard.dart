import 'package:flutter/material.dart';
import 'package:smartstock/core/services/util.dart';

numberPercentageCard(String? title, value, percentage) {
  return SizedBox(
    height: 112,
    child: Card(
      elevation: 1,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 24, 0, 8),
            child: Text(
              "$title",
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xFF1C1C1C)),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(24, 0, 8, 24),
                child: Text(
                  compactNumber(value),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    color: Color(0xFF1C1C1C),
                    // overflow: TextOverflow.fade,
                  ),
                  textAlign: TextAlign.left
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 24, 24),
                child: Text(
                  percentage == null
                      ? ''
                      : percentage > 0
                          ? "+$percentage%"
                          : "$percentage%",
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xFF1C1C1C),
                    overflow: TextOverflow.ellipsis,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}
