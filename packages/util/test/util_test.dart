import 'package:test/test.dart';
import 'package:util/util.dart';

void main() {
  test('test', () {
    const util = UtilBase();
    expect(util, isA<UtilBase>());
  });
}
