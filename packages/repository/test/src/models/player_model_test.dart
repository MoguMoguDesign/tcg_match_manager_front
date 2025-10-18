import 'package:flutter_test/flutter_test.dart';
import 'package:repository/repository.dart';

void main() {
  group('PlayerModel のテスト', () {
    group('コンストラクタのテスト', () {
      test('正常にインスタンスを作成できる', () {
        const model = PlayerModel(
          playerId: 'player-123',
          name: 'テストプレイヤー',
          playerNumber: 1,
          status: 'ACTIVE',
          userId: 'user-123',
        );

        expect(model.playerId, 'player-123');
        expect(model.name, 'テストプレイヤー');
        expect(model.playerNumber, 1);
        expect(model.status, 'ACTIVE');
        expect(model.userId, 'user-123');
      });

      test('異なるステータスでインスタンスを作成できる', () {
        const model = PlayerModel(
          playerId: 'player-456',
          name: 'ドロップしたプレイヤー',
          playerNumber: 2,
          status: 'DROPPED',
          userId: 'user-456',
        );

        expect(model.playerId, 'player-456');
        expect(model.name, 'ドロップしたプレイヤー');
        expect(model.playerNumber, 2);
        expect(model.status, 'DROPPED');
        expect(model.userId, 'user-456');
      });
    });

    group('fromJson のテスト', () {
      test('JSONから正常にインスタンスを生成できる', () {
        final json = {
          'playerId': 'player-123',
          'name': 'テストプレイヤー',
          'playerNumber': 1,
          'status': 'ACTIVE',
          'userId': 'user-123',
        };

        final model = PlayerModel.fromJson(json);

        expect(model.playerId, 'player-123');
        expect(model.name, 'テストプレイヤー');
        expect(model.playerNumber, 1);
        expect(model.status, 'ACTIVE');
        expect(model.userId, 'user-123');
      });

      test('JSONから正常にドロップ状態のインスタンスを生成できる', () {
        final json = {
          'playerId': 'player-456',
          'name': 'ドロップしたプレイヤー',
          'playerNumber': 2,
          'status': 'DROPPED',
          'userId': 'user-456',
        };

        final model = PlayerModel.fromJson(json);

        expect(model.playerId, 'player-456');
        expect(model.status, 'DROPPED');
      });
    });

    group('toJson のテスト', () {
      test('JSONに正常に変換できる', () {
        const model = PlayerModel(
          playerId: 'player-123',
          name: 'テストプレイヤー',
          playerNumber: 1,
          status: 'ACTIVE',
          userId: 'user-123',
        );

        final json = model.toJson();

        expect(json['playerId'], 'player-123');
        expect(json['name'], 'テストプレイヤー');
        expect(json['playerNumber'], 1);
        expect(json['status'], 'ACTIVE');
        expect(json['userId'], 'user-123');
      });

      test('ドロップ状態のインスタンスをJSONに変換できる', () {
        const model = PlayerModel(
          playerId: 'player-456',
          name: 'ドロップしたプレイヤー',
          playerNumber: 2,
          status: 'DROPPED',
          userId: 'user-456',
        );

        final json = model.toJson();

        expect(json['playerId'], 'player-456');
        expect(json['status'], 'DROPPED');
      });
    });

    group('copyWith のテスト', () {
      test('playerId を更新できる', () {
        const model = PlayerModel(
          playerId: 'player-123',
          name: 'テストプレイヤー',
          playerNumber: 1,
          status: 'ACTIVE',
          userId: 'user-123',
        );

        final updated = model.copyWith(playerId: 'player-456');

        expect(updated.playerId, 'player-456');
        expect(updated.name, 'テストプレイヤー');
        expect(updated.playerNumber, 1);
      });

      test('name を更新できる', () {
        const model = PlayerModel(
          playerId: 'player-123',
          name: 'テストプレイヤー',
          playerNumber: 1,
          status: 'ACTIVE',
          userId: 'user-123',
        );

        final updated = model.copyWith(name: '新しい名前');

        expect(updated.playerId, 'player-123');
        expect(updated.name, '新しい名前');
      });

      test('playerNumber を更新できる', () {
        const model = PlayerModel(
          playerId: 'player-123',
          name: 'テストプレイヤー',
          playerNumber: 1,
          status: 'ACTIVE',
          userId: 'user-123',
        );

        final updated = model.copyWith(playerNumber: 2);

        expect(updated.playerNumber, 2);
        expect(updated.name, 'テストプレイヤー');
      });

      test('status を更新できる', () {
        const model = PlayerModel(
          playerId: 'player-123',
          name: 'テストプレイヤー',
          playerNumber: 1,
          status: 'ACTIVE',
          userId: 'user-123',
        );

        final updated = model.copyWith(status: 'DROPPED');

        expect(updated.status, 'DROPPED');
        expect(updated.name, 'テストプレイヤー');
      });

      test('userId を更新できる', () {
        const model = PlayerModel(
          playerId: 'player-123',
          name: 'テストプレイヤー',
          playerNumber: 1,
          status: 'ACTIVE',
          userId: 'user-123',
        );

        final updated = model.copyWith(userId: 'user-456');

        expect(updated.userId, 'user-456');
        expect(updated.name, 'テストプレイヤー');
      });

      test('複数のフィールドを同時に更新できる', () {
        const model = PlayerModel(
          playerId: 'player-123',
          name: 'テストプレイヤー',
          playerNumber: 1,
          status: 'ACTIVE',
          userId: 'user-123',
        );

        final updated = model.copyWith(
          name: '新しい名前',
          playerNumber: 2,
          status: 'DROPPED',
        );

        expect(updated.playerId, 'player-123');
        expect(updated.name, '新しい名前');
        expect(updated.playerNumber, 2);
        expect(updated.status, 'DROPPED');
        expect(updated.userId, 'user-123');
      });
    });

    group('equality のテスト', () {
      test('同じ値を持つインスタンスは等しい', () {
        const model1 = PlayerModel(
          playerId: 'player-123',
          name: 'テストプレイヤー',
          playerNumber: 1,
          status: 'ACTIVE',
          userId: 'user-123',
        );

        const model2 = PlayerModel(
          playerId: 'player-123',
          name: 'テストプレイヤー',
          playerNumber: 1,
          status: 'ACTIVE',
          userId: 'user-123',
        );

        expect(model1, equals(model2));
        expect(model1.hashCode, equals(model2.hashCode));
      });

      test('異なる値を持つインスタンスは等しくない', () {
        const model1 = PlayerModel(
          playerId: 'player-123',
          name: 'テストプレイヤー',
          playerNumber: 1,
          status: 'ACTIVE',
          userId: 'user-123',
        );

        const model2 = PlayerModel(
          playerId: 'player-456',
          name: 'テストプレイヤー',
          playerNumber: 1,
          status: 'ACTIVE',
          userId: 'user-123',
        );

        expect(model1, isNot(equals(model2)));
      });
    });
  });
}
