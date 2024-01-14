import 'dart:async';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/LabelMedium.dart';
import 'package:smartstock/core/components/LabelSmall.dart';
import 'package:smartstock/core/components/info_dialog.dart';
import 'package:smartstock/core/models/file_data.dart';
import 'package:smartstock/core/helpers/util.dart';

class _FilePreview extends StatelessWidget {
  final dynamic data;

  // final int index;
  final String Function() onGetExtension;
  final VoidCallback onClose;

  const _FilePreview({
    super.key,
    required this.data,
    // required this.index,
    required this.onGetExtension,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      margin: const EdgeInsets.only(left: 8, bottom: 8),
      child: Stack(
        children: [
          Positioned(
            width: 80,
            height: 80,
            bottom: 0,
            left: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: data is String && '$data'.startsWith('http')
                  ? Image.network(
                      data,
                      fit: BoxFit.cover,
                      errorBuilder: _getErrorBuilder,
                    )
                  : Image.memory(
                      data,
                      fit: BoxFit.cover,
                      errorBuilder: _getErrorBuilder,
                    ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(100)),
              child: InkWell(
                onTap: onClose,
                // () {
                // setState(() {
                //   var index = _previews.indexOf(e);
                //   _previews.removeAt(index);
                //   _filesData.removeAt(index);
                //   widget.onFiles(_filesData);
                // });
                // },
                child: const Icon(Icons.close),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _getErrorBuilder(context, error, stackTrace) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border:
            Border.all(color: Theme.of(context).colorScheme.primaryContainer),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.file_present_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: LabelSmall(
                  text: firstLetterUpperCase(
                    '${onGetExtension()} file'.trim(),
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

class FileSelect extends StatefulWidget {
  final List<FileData?>? files;
  final Function(List<FileData?> file) onFiles;
  final Widget Function(bool isEmpty, VoidCallback onPress)? builder;

  const FileSelect(
      {super.key, required this.onFiles, this.builder, this.files});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<FileSelect> {
  final List<FileData?> _filesData = [];

  final List _previews = [];

  @override
  void initState() {
    setState(() {
      var files = widget.files;
      if (files != null) {
        _filesData.addAll(files);
        for (var element in _filesData) {
          var stream = element?.stream;
          var path = element?.path;
          if (stream != null) {
            _previews.add(Uint8List.fromList(stream));
          } else if (path is String &&
              path.isNotEmpty &&
              path.trim().startsWith('http')) {
            _previews.add(path);
          }
        }
      }
    });
    // print(_previews);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var hasPreview = _previews.isNotEmpty;
    // && _isImage(_filesData);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        hasPreview
            ? Wrap(
                children: _previews.map((e) {
                  return _FilePreview(
                    data: e,
                    onGetExtension: () {
                      return _filesData[_previews.indexOf(e)]?.extension ?? '';
                    },
                    onClose: () {
                      setState(() {
                        var index = _previews.indexOf(e);
                        _previews.removeAt(index);
                        _filesData.removeAt(index);
                        widget.onFiles(_filesData);
                      });
                    },
                  );
                }).toList(),
              )
            : Container(),
        widget.builder != null
            ? widget.builder!(!hasPreview, _onUploadReceipt)
            : Container(
                // height: 48,
                margin: const EdgeInsets.only(bottom: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _filesData.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(8),
                            child: LabelMedium(
                                text: _filesData
                                    .map((e) => e?.name ?? '')
                                    .join(', ')),
                          )
                        : const SizedBox(),
                    SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: _onUploadReceipt,
                        child: const BodyLarge(text: 'Click to attach file'),
                      ),
                    ),
                  ],
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
          _filesData.add(FileData(
            stream: platformFile.bytes!.toList(),
            extension: platformFile.extension,
            size: doubleOrZero(platformFile.size),
            name: platformFile.name,
            path: null,
          ));
          if (platformFile.bytes != null) {
            _previews.add(platformFile.bytes!);
          }
          setState(() {});
          widget.onFiles(_filesData);
        } else {
          // showInfoDialog(context, "Fail to get selected file");
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

// bool _isImage(List<FileData?> data) {
//   return data.map((e) => e?.extension ?? '_').fold(true,
//       (a, b) => a && (b == 'jpg' || b == 'png' || b == 'jpeg' || b == 'gif'));
//   // var es = extension;
//   // if (es == 'jpg' || es == 'png' || es == 'jpeg' || es == 'gif') {
//   //   return true;
//   // }
//   // return false;
// }
//
// Stream<List<int>>? _copyStream(Stream<List<int>>? stream) {
//   if (stream == null) {
//     return null;
//   }
//   return stream.map((event) => [...event]);
// }
}
