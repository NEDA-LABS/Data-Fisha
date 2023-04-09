import 'package:flutter/material.dart';

class ExternalService {
  String name;
  IconData icon;
  String pageLink;
  Widget Function(BuildContext context,dynamic args) onBuild;

  ExternalService({
    required this.name,
    required this.icon,
    required this.pageLink,
    required this.onBuild
  });
}
