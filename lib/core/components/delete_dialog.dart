import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyMedium.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/services/util.dart';

class DeleteDialog extends StatefulWidget {
  final String message;
  final Future Function() onConfirm;

  const DeleteDialog({
    required this.message,
    required this.onConfirm,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<DeleteDialog> {
  bool loading = false;
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Wrap(
          children: [
            const Text('Info',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                widget.message,
                softWrap: true,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: OutlinedButton(
                    onPressed: loading ? null : _handleOk,
                    child:
                        BodyMedium(text: loading ? 'Processing...' : 'Proceed'),
                  ),
                ),
                const WhiteSpacer(width: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    child: const BodyMedium(text: 'Cancel'),
                  ),
                ),
              ],
            ),
            error.isNotEmpty
                ? Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    width: MediaQuery.of(context).size.width,
                    child:
                        Text(error, style: const TextStyle(color: Colors.red)))
                : Container()
          ],
        ),
      ),
    );
  }

  _handleOk() {
    setState(() {
      loading = true;
    });
    widget
        .onConfirm()
        .then((value) => Navigator.of(context).maybePop())
        .catchError((err) {
      setState(() {
        error = '$err';
      });
      return err;
    }).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }
}
