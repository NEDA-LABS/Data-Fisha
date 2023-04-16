import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:smartstock/core/components/CameraView.dart';

class ReadBarcodeView extends StatefulWidget {
  const ReadBarcodeView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ReadBarcodeView> {
  final BarcodeScanner _barcodeScanner = BarcodeScanner();
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CameraDescription>>(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CameraView(
            title: 'Scan barcode or QR code',
            customPaint: _customPaint,
            onImage: (inputImage) {
                _processImage(inputImage).then((value) {
                  if (value is String) {
                    if (mounted && _canProcess) {
                      _canProcess=false;
                      Navigator.of(context).maybePop(value);
                    }
                  }
                }).catchError((error) {});
              // } else {
                // if (kDebugMode) {
                //   print('ALREADY HAVE PROCEDURE');
                // }
              // }
            },
            cameras: snapshot.data ?? [],
          );
        }
        return Container();
      },
      future: availableCameras(),
    );
  }

  @override
  void dispose() {
    _canProcess = false;
    _barcodeScanner.close();
    super.dispose();
  }

  Future _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    final barcodes = await _barcodeScanner.processImage(inputImage);
    var value = barcodes.isNotEmpty ? barcodes[0].rawValue : null;
    _isBusy = false;
    return value;
  }
}
