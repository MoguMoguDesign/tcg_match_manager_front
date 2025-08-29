import 'package:flutter_test/flutter_test.dart';
import 'package:repository/src/flexible_bool_converter.dart';

void main() {
  group('FlexibleBoolConverter のテスト。', () {
    group('定数インスタンスのテスト。', () {
      test('flexibleBoolConverter のデフォルト値が false である。', () {
        expect(flexibleBoolConverter.defaultValue, false);
      });

      test('flexibleBoolConverterTrueDefault のデフォルト値が true である。', () {
        expect(flexibleBoolConverterTrueDefault.defaultValue, true);
      });
    });

    group('fromJson メソッドのテスト。', () {
      group('null 入力のテスト。', () {
        test('flexibleBoolConverter で null を渡した場合、false を返す。', () {
          final result = flexibleBoolConverter.fromJson(null);
          expect(result, false);
        });

        test('flexibleBoolConverterTrueDefault で null を渡した場合、true を返す。', () {
          final result = flexibleBoolConverterTrueDefault.fromJson(null);
          expect(result, true);
        });
      });

      group('String 型入力のテスト。', () {
        test('"0" を渡した場合、false を返す。', () {
          final result = flexibleBoolConverter.fromJson('0');
          expect(result, false);
        });

        test('"1" を渡した場合、true を返す。', () {
          final result = flexibleBoolConverter.fromJson('1');
          expect(result, true);
        });

        test('"0" と "1" 以外の文字列を渡した場合、true を返す。', () {
          final testCases = ['2', 'true', 'false', 'yes', 'no', '', 'other'];

          for (final testCase in testCases) {
            final result = flexibleBoolConverter.fromJson(testCase);
            expect(
              result,
              true,
              reason: 'String "$testCase" should return true',
            );
          }
        });
      });

      group('int 型入力のテスト。', () {
        test('0 を渡した場合、false を返す。', () {
          final result = flexibleBoolConverter.fromJson(0);
          expect(result, false);
        });

        test('1 を渡した場合、true を返す。', () {
          final result = flexibleBoolConverter.fromJson(1);
          expect(result, true);
        });

        test('0 と 1 以外の整数を渡した場合、true を返す。', () {
          final testCases = [-1, 2, 10, -10, 999];

          for (final testCase in testCases) {
            final result = flexibleBoolConverter.fromJson(testCase);
            expect(result, true, reason: 'int $testCase should return true');
          }
        });
      });

      group('その他の型入力のテスト。', () {
        test('bool 型を渡した場合、flexibleBoolConverter はデフォルト値 false を返す。', () {
          final result1 = flexibleBoolConverter.fromJson(true);
          final result2 = flexibleBoolConverter.fromJson(false);
          expect(result1, false);
          expect(result2, false);
        });

        test(
          'bool 型を渡した場合、flexibleBoolConverterTrueDefault はデフォルト値 true を返す。',
          () {
            final result1 = flexibleBoolConverterTrueDefault.fromJson(true);
            final result2 = flexibleBoolConverterTrueDefault.fromJson(false);
            expect(result1, true);
            expect(result2, true);
          },
        );

        test('double 型を渡した場合、flexibleBoolConverter はデフォルト値 false を返す。', () {
          final result = flexibleBoolConverter.fromJson(3.14);
          expect(result, false);
        });

        test(
          'double 型を渡した場合、flexibleBoolConverterTrueDefault はデフォルト値 true を返す。',
          () {
            final result = flexibleBoolConverterTrueDefault.fromJson(3.14);
            expect(result, true);
          },
        );

        test('List 型を渡した場合、flexibleBoolConverter はデフォルト値 false を返す。', () {
          final result = flexibleBoolConverter.fromJson([1, 2, 3]);
          expect(result, false);
        });

        test(
          'List 型を渡した場合、flexibleBoolConverterTrueDefault はデフォルト値 true を返す。',
          () {
            final result = flexibleBoolConverterTrueDefault.fromJson([1, 2, 3]);
            expect(result, true);
          },
        );

        test('Map 型を渡した場合、flexibleBoolConverter はデフォルト値 false を返す。', () {
          final result = flexibleBoolConverter.fromJson({'key': 'value'});
          expect(result, false);
        });

        test(
          'Map 型を渡した場合、flexibleBoolConverterTrueDefault はデフォルト値 true を返す。',
          () {
            final result = flexibleBoolConverterTrueDefault.fromJson({
              'key': 'value',
            });
            expect(result, true);
          },
        );
      });
    });

    group('toJson メソッドのテスト。', () {
      test('true を渡した場合、UnimplementedError がスローされる。', () {
        expect(
          () => flexibleBoolConverter.toJson(true),
          throwsA(isA<UnimplementedError>()),
        );
        expect(
          () => flexibleBoolConverterTrueDefault.toJson(true),
          throwsA(isA<UnimplementedError>()),
        );
      });

      test('false を渡した場合、UnimplementedError がスローされる。', () {
        expect(
          () => flexibleBoolConverter.toJson(false),
          throwsA(isA<UnimplementedError>()),
        );
        expect(
          () => flexibleBoolConverterTrueDefault.toJson(false),
          throwsA(isA<UnimplementedError>()),
        );
      });
    });
  });
}
