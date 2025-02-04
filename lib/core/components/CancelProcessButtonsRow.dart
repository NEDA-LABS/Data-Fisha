import 'package:flutter/cupertino.dart';
import 'package:smartstock/core/components/PrimaryAction.dart';
import 'package:smartstock/core/components/TertriaryAction.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';

class CancelProcessButtonsRow extends StatelessWidget {
  final String? cancelText;
  final String? proceedText;
  final VoidCallback? onCancel;
  final VoidCallback? onProceed;

  const CancelProcessButtonsRow({
    super.key,
    this.cancelText,
    this.proceedText,
    this.onCancel,
    this.onProceed,
  });

  @override
  Widget build(BuildContext context) {
    // var isSmallScreen = getIsSmallScreen(context);
    return Row(
      children: [
        // proceedText == null && !isSmallScreen
        //     ? Expanded(flex: 1, child: Container())
        //     : Container(),
        Expanded(
          flex: 1,
          child: cancelText != null
              ? TertiaryAction(
                  onPressed: onCancel ?? () {}, text: cancelText ?? 'Cancel')
              : Container(),
        ),
        WhiteSpacer(width: proceedText != null ? 16 : 0),
        proceedText != null
            ? Expanded(
                flex: 1,
                child: PrimaryAction(
                    onPressed: onProceed ?? () {},
                    text: proceedText ?? 'Proceed'))
            : Container()
      ],
    );
  }
}
