import 'package:base_ui/base_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('base_ui test', () {
    // サンプル用テスト。
    expect(CommonDateFormat.formatYMMMd, isA<Function>());
  });
}
