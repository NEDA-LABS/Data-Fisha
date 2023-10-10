import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/LabelMedium.dart';

dataExportOptions({onPdf,onCsv, onExcel}){
  return Container(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: const BodyLarge(text: 'Export Excel'),
          subtitle: const LabelMedium(text: 'microsoft xlsx format'),
          leading: const Icon(Icons.document_scanner),
          onTap: onExcel,
        ),
        ListTile(
          title: const BodyLarge(text:'Export PDF'),
          subtitle: const LabelMedium(text: 'with graphs and images'),
          leading: const Icon(Icons.file_present_rounded),
          onTap: onPdf,
        ),
        ListTile(
          title: const BodyLarge(text:'Export CSV'),
          subtitle: const LabelMedium(text: 'comma separated'),
          leading: const Icon(Icons.offline_bolt_outlined),
          onTap: onCsv,
        ),
      ],
    ),
  );
}