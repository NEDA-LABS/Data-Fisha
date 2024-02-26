import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/BodyMedium.dart';
import 'package:smartstock/core/components/LabelLarge.dart';
import 'package:smartstock/core/components/TitleMedium.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/info_dialog.dart';

class DeleteDialog extends StatefulWidget {
  final String message;
  final Future Function() onConfirm;
  final Function(dynamic) onDone;

  const DeleteDialog({
    required this.message,
    required this.onConfirm,
    required this.onDone,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<DeleteDialog> {
  bool loading = false;
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Wrap(
          children: [
            const TitleMedium(text: 'Info'),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: BodyLarge(text: widget.message),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextButton(
                    onPressed: loading ? null : _handleOk,
                    child: BodyLarge(
                      text: loading ? 'Processing...' : 'Delete',
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
                const WhiteSpacer(width: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    child: BodyLarge(
                      text: 'Cancel',
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            // error.isNotEmpty
            //     ? Container(
            //         padding: const EdgeInsets.symmetric(vertical: 8),
            //         width: MediaQuery.of(context).size.width,
            //         child: LabelLarge(
            //           text: error,
            //           color: Theme.of(context).colorScheme.error,
            //         ))
            //     : Container()
          ],
        ),
      ),
    );
  }

  _handleOk() {
    setState(() {
      loading = true;
    });
    widget.onConfirm().then((value) {
      widget.onDone(value);
    }).catchError((err) {
      showTransactionCompleteDialog(context, err);
    }).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }
}
