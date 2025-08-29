import 'package:flutter_test/flutter_test.dart';
import 'package:system/system.dart';

void main() {
  test('test', () {
    const system = SystemBase();
    expect(system, isA<SystemBase>());
  });
}
