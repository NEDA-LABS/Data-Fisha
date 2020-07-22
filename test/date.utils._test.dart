import 'package:flutter_test/flutter_test.dart';
import 'package:smartstock_pos/shared/date.utils.dart';

void main(){
  test("should convert date to sql date", () {
    var sqlDate = toSqlDate(DateTime.parse('2020-07-22 16:12:30.768817'));
    // print(sqlDate);
    expect(sqlDate,'2020-07-22');
  });
}
