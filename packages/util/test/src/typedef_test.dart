import 'package:test/test.dart';
import 'package:util/util.dart';

void main() {
  group('JsonMap のテスト。', () {
    test('基本的な Map 操作が可能である。', () {
      final JsonMap map = {'a': 1, 'b': 'text'};
      expect(map['a'], 1);
      expect(map['b'], 'text');

      map['c'] = true;
      expect(map['c'], true);
    });

    test('入れ子の JsonMap を扱える。', () {
      final JsonMap nested = {
        'child': <String, dynamic>{'value': 42},
      };
      expect((nested['child'] as Map<String, dynamic>)['value'], 42);
    });
  });
}
