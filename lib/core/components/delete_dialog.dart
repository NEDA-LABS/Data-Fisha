import 'package:flutter/material.dart';
import 'package:smartstock/core/services/util.dart';

deleteDialog(
    {required String message, required Future Function() onConfirm}) {
  bool loading = false;
  String error = '';
  return StatefulBuilder(
      builder: (context, setState) => Dialog(
          child: Container(
              padding: const EdgeInsets.all(16),
              constraints: const BoxConstraints(maxWidth: 400),
              child: Wrap(children: [
                const Text('Info',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(message,
                        softWrap: true,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400))),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: OutlinedButton(
                        onPressed: loading
                            ? null
                            : () {
                                setState(() {
                                  loading = true;
                                });
                                onConfirm()
                                    .then((value) => navigator().maybePop())
                                    .catchError((err) {
                                  setState(() {
                                    error = '$err';
                                  });
                                }).whenComplete(() {
                                  setState(() {
                                    loading = false;
                                  });
                                });
                              },
                        child: Text(loading ? 'Processing...' : 'Yes'))),
                error.isNotEmpty
                    ? Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        width: MediaQuery.of(context).size.width,
                        child: Text(error,
                            style: const TextStyle(color: Colors.red)))
                    : Container()
              ]))));
}
