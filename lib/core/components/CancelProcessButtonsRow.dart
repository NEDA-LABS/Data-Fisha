import 'package:flutter/cupertino.dart';
import 'package:smartstock/core/components/PrimaryAction.dart';
import 'package:smartstock/core/components/TertriaryAction.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';

class CancelProcessButtonsRow extends StatelessWidget {
  final String? cancelText;
  final String? proceedText;
  final VoidCallback? onCancel;
  final VoidCallback? onProceed;

  const CancelProcessButtonsRow(
      {super.key,
      this.cancelText,
      this.proceedText,
      this.onCancel,
      this.onProceed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: cancelText != null
              ? TertiaryAction(
                  onPressed: onCancel ?? () {}, text: cancelText ?? '')
              : Container(),
        ),
        const WhiteSpacer(width: 16),
        Expanded(
          flex: 1,
          child: proceedText != null
              ? PrimaryAction(
                  onPressed: onProceed ?? () {}, text: proceedText ?? '')
              : Container(),
        )
      ],
    );
  }
}
