import 'package:flutter/material.dart';
import 'package:smartstock/core/components/solid_radius_decoration.dart';
import 'package:smartstock/core/services/util.dart';

class NumberPercentageCard extends StatelessWidget {
  final String? title;
  final dynamic value;
  final dynamic percentage;
  final bool isWarning;
  final bool isDanger;

  const NumberPercentageCard(
    this.title,
    this.value,
    this.percentage, {
    Key? key,
    this.isWarning = false,
    this.isDanger = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var normalColor=Theme.of(context).colorScheme.surfaceVariant;
    var dangerColor=Theme.of(context).colorScheme.errorContainer;
    var warningColor=Theme.of(context).colorScheme.secondaryContainer;
    var color = isWarning?warningColor:isDanger?dangerColor:normalColor;
    return Card(
      // height: 112,
      elevation: 0,
      margin: const EdgeInsets.all(5),
      color: color,
      child: Container(
        decoration: solidRadiusBoxDecoration(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 24, 0, 8),
              child: Text(
                "$title",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  // color: Color(0xFF1C1C1C),
                ),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 8, 24),
                  child: Text(compactNumber(value),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        // color: Color(0xFF1C1C1C),
                        // overflow: TextOverflow.fade,
                      ),
                      textAlign: TextAlign.left),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
