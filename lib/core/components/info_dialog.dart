import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/CancelProcessButtonsRow.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/helpers/dialog_or_bottom_sheet.dart';

Future showTransactionCompleteDialog(
  context,
  message, {
  String title = 'Info',
  VoidCallback? onClose,
  VoidCallback? onPrint,
}) {
  var isContainError = title.toLowerCase().contains('error');
  var errorColor = Theme.of(context).colorScheme.error;
  var onErrorColor = Theme.of(context).colorScheme.onError;
  var primaryColor = Theme.of(context).colorScheme.primary;
  var onPrimaryColor = Theme.of(context).colorScheme.onPrimary;
  var view = Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const WhiteSpacer(height: 24),
      Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
            border: Border.all(
                color: isContainError ? errorColor : primaryColor, width: 2),
            borderRadius: BorderRadius.circular(38)),
        child: Container(
          width: 35,
          height: 35,
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            color: isContainError ? errorColor : primaryColor,
          ),
          child: Center(
            child: Icon(
              isContainError ? Icons.close : Icons.check,
              color: isContainError ? onErrorColor : onPrimaryColor,
            ),
          ),
        ),
      ),
      // const WhiteSpacer(height: 16),
      // TitleMedium(text: title),
      //   child:
      const WhiteSpacer(height: 16),
      // ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: BodyLarge(text: '$message', textAlign: TextAlign.center),
      ),
      // onPrint != null ? const WhiteSpacer(height: 16) : Container(),
      // onPrint != null
      //     ? PrimaryAction(text: "Print Receipt", onPressed: () {})
      //     : Container(),
      Container(height: 24, width: 0, color: Colors.transparent),
      Container(
        constraints: const BoxConstraints(maxWidth: 400),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: CancelProcessButtonsRow(
          cancelText: 'Close',
          proceedText: onPrint != null ? 'Print Receipt' : null,
          onProceed: onPrint,
          onCancel: () {
            // if(canPop){
            Navigator.of(context).maybePop().whenComplete(() {
              if (onClose != null) {
                onClose();
              }
            });
            // }
          },
        ),
      ),
      Container(height: 24, width: 0, color: Colors.transparent),
    ],
  );

  return showDialogOrModalSheet(view, context, canClose: false);
}
