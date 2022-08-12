import 'package:flutter_test/flutter_test.dart';
import 'package:smartstock_pos/common/util.dart';

main(){
  test("combine functions", (){
    f1(a){
      print(a);
      return 1+a;
    };
    f2(b)=> b*2;
    var jibu = compose([f2,f1]);
    print(jibu);
    expect(jibu(1), 4);
  });
}