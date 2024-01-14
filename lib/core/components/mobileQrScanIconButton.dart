import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/ReadBarcodeView.dart';
import 'package:smartstock/core/components/full_screen_dialog.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/helpers/util.dart';

Widget mobileQrScanIconButton(BuildContext context, Function(dynamic code) onBarCode) {
  var a = ifDoElse(
        (_) => isNativeMobilePlatform(),
        (_) =>
        IconButton(
          onPressed: () {
            showFullScreeDialog(context, (p0) {
              return const ReadBarcodeView();
            }).then(onBarCode).catchError((error) {
              if (kDebugMode) {
                print(error);
              }
              onBarCode('');
            });
          },
          icon: const Icon(Icons.qr_code_scanner),
        ),
        (_) => const SizedBox(),
  );
  return a('');
}