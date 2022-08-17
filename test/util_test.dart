import 'package:flutter_test/flutter_test.dart';
import 'package:smartstock_pos/core/services/util.dart';

main() {
  group("Utils", () {
    test("return quantity if quantity is number", () {
      expect(getStockQuantity(stock: {'quantity': 1}), 1);
    });
    test("return zero if no quantity object", () {
      expect(getStockQuantity(stock: {}), 0);
    });
    test("return quantity if quantity is object", () {
      expect(
        getStockQuantity(
          stock: {
            'quantity': {
              'a': {'q': 10},
              'b': {'q': 1}
            }
          },
        ),
        11,
      );
    });
    test("return zero if is null", (){
      expect(getStockQuantity(stock: null), 0);
    });
  });
}
