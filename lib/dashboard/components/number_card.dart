import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/BodyMedium.dart';
import 'package:smartstock/core/components/TitleLarge.dart';
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
    super.key,
    this.isWarning = false,
    this.isDanger = false,
    this.onClick,
  });

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
    var borderColor = isWarning
        ? warningColor
        : isDanger
            ? dangerColor
            : Theme.of(context).colorScheme.primaryContainer;
    return Container(
      // height: 112,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(color: borderColor),
        color: color,
      ),
      margin: const EdgeInsets.all(5),
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
                child: BodyMedium(text:
                  "$title",
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 8, 24),
                alignment: Alignment.topLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: TitleLarge(text: formatNumber(value, decimals: 2)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
