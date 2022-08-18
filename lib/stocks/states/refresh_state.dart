import 'package:flutter/foundation.dart';

class RefreshState extends ChangeNotifier{
  refresh()=>notifyListeners();
}
