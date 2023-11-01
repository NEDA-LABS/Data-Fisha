import 'dart:async';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/info_dialog.dart';
import 'package:smartstock/core/models/file_data.dart';
import 'package:smartstock/core/services/util.dart';

class FileSelect extends StatefulWidget {
  final Function(FileData file) onFile;
  final Widget Function(bool isEmpty, VoidCallback onPress)? builder;

  const FileSelect({super.key, required this.onFile, this.builder});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<FileSelect> {
  FileData? _fileData;
  Uint8List? _preview;

  @override
  Widget build(BuildContext context) {
    var hasPreview = _fileData != null &&
        _preview != null &&
        _isImage(_fileData!.extension!);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        hasPreview
            ? Container(
                margin: const EdgeInsets.only(bottom: 16),
                // alignment: Alignment.topLeft,
                constraints: const BoxConstraints(
                  maxHeight: 350,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(_preview!, fit: BoxFit.cover),
                ),
              )
            // StreamBuilder(
            //         stream: _previewController.stream,
            //         builder: (context, snapshot) {
            //           if (snapshot.hasData) {
            //             // _stream = snapshot.data!;
            //             return Container(
            //               margin: const EdgeInsets.only(bottom: 16),
            //               // alignment: Alignment.topLeft,
            //               constraints: const BoxConstraints(
            //                 maxHeight: 350,
            //               ),
            //               child: ClipRRect(
            //                 borderRadius: BorderRadius.circular(8),
            //                 child: Image.memory(_preview!,
            //                     fit: BoxFit.cover),
            //               ),
            //             );
            //           }
            //           return Container();
            //         },
            //       )
            : Container(),
        widget.builder != null
            ? widget.builder!(!hasPreview, _onUploadReceipt)
            : Container(
                height: 48,
                margin: const EdgeInsets.only(bottom: 16),
                child: OutlinedButton(
                  onPressed: _onUploadReceipt,
                  child: BodyLarge(
                    text:
                        'Select${_fileData != null ? 'ed' : ''} file [ ${_fileData?.name ?? ''} ]',
                  ),
                ),
              ),
      ],
    );
  }

  void _onUploadReceipt() {
    handleFile(value) {
      FilePickerResult? result = value;
      PlatformFile? platformFile = result?.files.single;
      if (mounted) {
        if (platformFile != null && platformFile.bytes != null) {
          _fileData = FileData(
              stream: Stream.value(platformFile.bytes!.toList()),
              extension: platformFile.extension,
              size: doubleOrZero(platformFile.size),
              name: platformFile.name,
              path: null);
          // final subscription = platformFile.readStream?.listen(null);
          // subscription?.onData((event) {
          // Update onData after listening.
          _preview = platformFile.bytes;
          // subscription.cancel();
          setState(() {});
          // });
          // platformFile.readStream?.listen((event) {
          //
          // },).cancel();
          // platformFile.readStream?.single.then((value){
          //   _previewController.sink.add();
          // });
          widget.onFile(_fileData!);
        } else {
          showInfoDialog(context, "Fail to get selected file");
        }
      }
    }

    handleError(error) {
      if (mounted) {
        showInfoDialog(context, error);
      }
    }

    FilePicker.platform
        .pickFiles(
            allowMultiple: false,
            lockParentWindow: true,
            withReadStream: false,
            withData: true)
        .then(handleFile)
        .catchError(handleError);
  }

  bool _isImage(String extension) {
    var es = extension;
    if (es == 'jpg' || es == 'png' || es == 'jpeg' || es == 'gif') {
      return true;
    }
    return false;
  }

  Stream<List<int>>? _copyStream(Stream<List<int>>? stream) {
    if (stream == null) {
      return null;
    }
    return stream.map((event) => [...event]);
  }
}
