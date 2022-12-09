import 'package:flutter/material.dart';

dataExportOptions({onPdf,onCsv, onExcel}){
  var subStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.w200);
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      ListTile(
        title: const Text('Export Excel'),
        subtitle: Text('microsoft xlsx format', style: subStyle),
        leading: const Icon(Icons.document_scanner),
        onTap: onExcel,
      ),
      ListTile(
        title: const Text('Export PDF'),
        subtitle: Text('with graphs and images', style: subStyle),
        leading: const Icon(Icons.file_present_rounded),
        onTap: onPdf,
      ),
      ListTile(
        title: const Text('Export CSV'),
        subtitle: Text('comma separated', style: subStyle),
        leading: const Icon(Icons.offline_bolt_outlined),
        onTap: onCsv,
      ),
    ],
  );
}