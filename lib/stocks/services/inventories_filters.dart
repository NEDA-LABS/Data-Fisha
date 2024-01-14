import 'package:smartstock/core/helpers/util.dart';

getNegativeProductFilter(String key){
  return {
    key: (v) {
      return doubleOrZero(v['quantity']) < 0;
    }
  };
}

getZeroProductsFilter(String key){
  return {
    key: (v) {
      return doubleOrZero(v['quantity']) == 0;
    }
  };
}

getPositiveProductsFilter(String key){
  return {
    key: (v) {
      return doubleOrZero(v['quantity']) > 0;
    }
  };
}

getExpiredProductsFilter(String key){
  return {
    key: (v) {
      if(v['expire']==null){
        return false;
      }
      var date = DateTime.tryParse(v['expire']??'') ??
          DateTime.now().add(const Duration(days: 1));
      return date.compareTo(DateTime.now()) <= 0;
    }
  };
}

getNearExpiredProductsFilter(String key){
  return {
    key: (v) {
      if(v['expire']==null){
        return false;
      }
      var date = DateTime.tryParse(v['expire']??'') ??
          DateTime.now().add(const Duration(days: 1));
      return date
          .subtract(const Duration(days: 60))
          .compareTo(DateTime.now()) <=
          0;
    }
  };
}