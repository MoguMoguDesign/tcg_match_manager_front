import 'package:test/test.dart';
import 'package:util/util.dart';

/// テスト用の列挙型を定義する。
enum TestEnum {
  /// 第一の値。
  first,

  /// 第二の値。
  second,

  /// 第三の値。
  third,
}

/// 単一の値を持つテスト用の列挙型を定義する。
enum SingleValueEnum {
  /// 唯一の値。
  only,
}

void main() {
  group('EnumByName<T> 拡張機能のテスト。', () {
    test('有効な列挙型の名前で正しい値が返される。', () {
      // 正常なケース: 存在する名前での検索を実行する。
      expect(TestEnum.values.byNameOrNull('first'), equals(TestEnum.first));
      expect(TestEnum.values.byNameOrNull('second'), equals(TestEnum.second));
      expect(TestEnum.values.byNameOrNull('third'), equals(TestEnum.third));
    });

    test('無効な列挙型の名前で null が返される。', () {
      // 異常なケース: 存在しない名前での検索を実行する。
      expect(TestEnum.values.byNameOrNull('nonexistent'), isNull);
    });

    test('null 入力で null が返される。', () {
      // 異常なケース: null 入力での検索を実行する。
      expect(TestEnum.values.byNameOrNull(null), isNull);
    });

    test('空文字列入力で null が返される。', () {
      // 異常なケース: 空文字列での検索を実行する。
      expect(TestEnum.values.byNameOrNull(''), isNull);
    });

    test('大文字小文字を区別して検索される。', () {
      // 大文字小文字の区別が正しく機能することを確認する。
      expect(TestEnum.values.byNameOrNull('First'), isNull);
      expect(TestEnum.values.byNameOrNull('FIRST'), isNull);
      expect(TestEnum.values.byNameOrNull('first'), equals(TestEnum.first));
    });

    test('前後の空白文字を含む名前で null が返される。', () {
      // 空白文字を含む場合の検索を実行する。
      expect(TestEnum.values.byNameOrNull(' first'), isNull);
      expect(TestEnum.values.byNameOrNull('first '), isNull);
      expect(TestEnum.values.byNameOrNull(' first '), isNull);
    });

    test('単一の値を持つ列挙型で正しく動作する。', () {
      // 境界値テスト: 最小サイズ（単一値）の列挙型での動作を確認する。
      // 反復処理ロジックが最小ケースでも正しく動作することを検証する。
      // 実際のアプリケーションでも単一値の列挙型は存在する（開発段階や設定値など）。
      expect(
        SingleValueEnum.values.byNameOrNull('only'),
        equals(SingleValueEnum.only),
      );
      // 単一値の列挙型でも無効な名前では null が返されることを確認する。
      expect(SingleValueEnum.values.byNameOrNull('notfound'), isNull);
    });

    test('公式の byName メソッドとの比較テスト。', () {
      // 公式の byName メソッドとの動作比較を実行する。
      // 正常なケース: 両方とも同じ値を返すことを確認する。
      expect(
        TestEnum.values.byNameOrNull('first'),
        equals(TestEnum.values.byName('first')),
      );
      expect(
        TestEnum.values.byNameOrNull('second'),
        equals(TestEnum.values.byName('second')),
      );

      // 異常なケース: byName は ArgumentError を投げ、byNameOrNull は null を返すことを確認する。
      expect(() => TestEnum.values.byName('nonexistent'), throwsArgumentError);
      expect(TestEnum.values.byNameOrNull('nonexistent'), isNull);
    });

    test('プロパティベーステスト: すべての列挙型の値に対して基本的な性質を検証する。', () {
      // 網羅的カバレッジ: 手動テストでカバーされない値も含めて、すべての値を自動的にテスト。
      // 完全性保証: 列挙型の変更時も取りこぼしなく全値の動作を確認する。
      for (final enumValue in TestEnum.values) {
        expect(
          TestEnum.values.byNameOrNull(enumValue.name),
          equals(enumValue),
          reason: '列挙型 ${enumValue.name} の検索に失敗しました。',
        );
      }
    });
  });
}
