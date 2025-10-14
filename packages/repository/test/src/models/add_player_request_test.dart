import 'package:flutter_test/flutter_test.dart';
import 'package:repository/repository.dart';

void main() {
  group('AddPlayerRequest のテスト', () {
    group('コンストラクタのテスト', () {
      test('正常にインスタンスを作成できる', () {
        const request = AddPlayerRequest(
          name: 'テストプレイヤー',
          playerNumber: 1,
          userId: 'user-123',
        );

        expect(request.name, 'テストプレイヤー');
        expect(request.playerNumber, 1);
        expect(request.userId, 'user-123');
      });
    });

    group('fromJson のテスト', () {
      test('JSON から正常にインスタンスを生成できる', () {
        final json = {
          'name': 'テストプレイヤー',
          'playerNumber': 1,
          'userId': 'user-123',
        };

        final request = AddPlayerRequest.fromJson(json);

        expect(request.name, 'テストプレイヤー');
        expect(request.playerNumber, 1);
        expect(request.userId, 'user-123');
      });
    });

    group('toJson のテスト', () {
      test('JSON に正常に変換できる', () {
        const request = AddPlayerRequest(
          name: 'テストプレイヤー',
          playerNumber: 1,
          userId: 'user-123',
        );

        final json = request.toJson();

        expect(json['name'], 'テストプレイヤー');
        expect(json['playerNumber'], 1);
        expect(json['userId'], 'user-123');
      });
    });

    group('copyWith のテスト', () {
      test('name のみを更新できる', () {
        const request = AddPlayerRequest(
          name: 'テストプレイヤー',
          playerNumber: 1,
          userId: 'user-123',
        );

        final updated = request.copyWith(name: '新しい名前');

        expect(updated.name, '新しい名前');
        expect(updated.playerNumber, 1);
        expect(updated.userId, 'user-123');
      });

      test('playerNumber のみを更新できる', () {
        const request = AddPlayerRequest(
          name: 'テストプレイヤー',
          playerNumber: 1,
          userId: 'user-123',
        );

        final updated = request.copyWith(playerNumber: 2);

        expect(updated.name, 'テストプレイヤー');
        expect(updated.playerNumber, 2);
        expect(updated.userId, 'user-123');
      });

      test('userId のみを更新できる', () {
        const request = AddPlayerRequest(
          name: 'テストプレイヤー',
          playerNumber: 1,
          userId: 'user-123',
        );

        final updated = request.copyWith(userId: 'user-456');

        expect(updated.name, 'テストプレイヤー');
        expect(updated.playerNumber, 1);
        expect(updated.userId, 'user-456');
      });
    });

    group('equality のテスト', () {
      test('同じ値を持つインスタンスは等しい', () {
        const request1 = AddPlayerRequest(
          name: 'テストプレイヤー',
          playerNumber: 1,
          userId: 'user-123',
        );

        const request2 = AddPlayerRequest(
          name: 'テストプレイヤー',
          playerNumber: 1,
          userId: 'user-123',
        );

        expect(request1, equals(request2));
        expect(request1.hashCode, equals(request2.hashCode));
      });

      test('異なる値を持つインスタンスは等しくない', () {
        const request1 = AddPlayerRequest(
          name: 'テストプレイヤー',
          playerNumber: 1,
          userId: 'user-123',
        );

        const request2 = AddPlayerRequest(
          name: '別のプレイヤー',
          playerNumber: 1,
          userId: 'user-123',
        );

        expect(request1, isNot(equals(request2)));
      });
    });
  });
}
