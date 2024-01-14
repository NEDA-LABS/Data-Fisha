import 'package:flutter/material.dart';
import 'package:smartstock/core/helpers/util.dart';

class NumberCard extends StatelessWidget {
  final String? title;
  final dynamic value;
  final dynamic percentage;
  final bool isWarning;
  final bool isDanger;
  final Function()? onClick;

  const NumberCard(
    this.title,
    this.value,
    this.percentage, {
    Key? key,
    this.isWarning = false,
    this.isDanger = false,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var normalColor = Theme.of(context).colorScheme.surfaceVariant;
    var dangerColor = Theme.of(context).colorScheme.errorContainer;
    var warningColor = Theme.of(context).colorScheme.secondaryContainer;
    var color = isWarning
        ? warningColor
        : isDanger
            ? dangerColor
            : normalColor;
    return Card(
      // height: 112,
      elevation: 0,
      margin: const EdgeInsets.all(5),
      color: color,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onClick,
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
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
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 8, 24),
                alignment: Alignment.topLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(formatNumber(value, decimals: 2),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        // color: Color(0xFF1C1C1C),
                        // overflow: TextOverflow.fade,
                      ),
                      textAlign: TextAlign.left),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
