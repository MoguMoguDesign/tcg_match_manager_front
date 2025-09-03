import 'package:test/test.dart';

void main() {
  group('JsonMap のテスト。', () {
    test('基本的な Map 操作が可能である。', () {
      final map = {'a': 1, 'b': 'text'};
      expect(map['a'], 1);
      expect(map['b'], 'text');

      map['c'] = true;
      expect(map['c'], true);
    });

    test('入れ子の JsonMap を扱える。', () {
      final nested = {
        'child': <String, dynamic>{'value': 42},
      };
      expect(nested['child']!['value'], 42);
    });
  });
}
