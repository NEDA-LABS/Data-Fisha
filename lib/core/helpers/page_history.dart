import 'package:smartstock/core/pages/page_base.dart';

class PageHistory {
  static final PageHistory _instance = PageHistory._internal();
  final List<PageBase> _pageHistories = [];

  factory PageHistory() {
    return _instance;
  }

  PageHistory._internal();

  void openFile() {}
  void writeFile() {}
  int getLength(){
    return _pageHistories.length;
  }
  bool getIsNotEmpty(){
    return _pageHistories.isNotEmpty;
  }
  PageBase getLast(){
    return _pageHistories.last;
  }
  void add(PageBase page){
    _pageHistories.add(page);
  }

  PageBase? getAt(int index){
    return _pageHistories[index];
  }

  void removeAt(int index){
    _pageHistories.removeAt(index);
  }
}