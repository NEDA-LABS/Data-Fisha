import 'package:flutter/cupertino.dart';

abstract class PageBase extends StatefulWidget{
  final String pageName;
  const PageBase({super.key, required this.pageName});
}