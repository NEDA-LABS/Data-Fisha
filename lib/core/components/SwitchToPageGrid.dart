import 'package:flutter/material.dart';

class SwitchToPageGrid extends StatelessWidget {
  final Function() onPress;
  final Widget Function()? onIcon;
  final String name;

  const SwitchToPageGrid({
    Key? key,
    required this.onPress,
    this.onIcon,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 81,
      margin: const EdgeInsets.only(right: 10, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        color: Theme.of(context).colorScheme.surfaceVariant,
      ),
      child: InkWell(
        onTap: onPress,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 14, left: 10, right: 10),
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
              child: onIcon != null ? onIcon!() : Container(),
            ),
            Container(
              padding: const EdgeInsets.only(right: 5, top: 13, bottom: 5),
              alignment: Alignment.topLeft,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
