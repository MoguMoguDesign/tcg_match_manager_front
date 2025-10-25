import 'package:test/test.dart';

import '../../generators/small_tournament_generator.dart';

void main() {
  group('SmallTournamentGenerator のテスト。', () {
    late SmallTournamentGenerator generator;

    setUp(() {
      generator = SmallTournamentGenerator();
    });

    group('generate メソッドのテスト。', () {
      test('正しいトーナメント ID を生成する。', () {
        final result = generator.generate();

        expect(result.tournamentId, equals('test-tournament-small-001'));
      });

      test('8 人のプレイヤーデータを生成する。', () {
        final result = generator.generate();

        expect(result.players.length, equals(8));
      });

      test('2 ラウンドのデータを生成する。', () {
        final result = generator.generate();

        expect(result.rounds.length, equals(2));
      });

      test('トーナメントステータスが IN_PROGRESS である。', () {
        final result = generator.generate();

        expect(result.tournament['status'], equals('IN_PROGRESS'));
      });

      test('現在ラウンドが 2 である。', () {
        final result = generator.generate();

        expect(result.tournament['currentRound'], equals(2));
      });

      test('プレイヤー数が正しく設定される。', () {
        final result = generator.generate();

        expect(result.tournament['playerCount'], equals(8));
        expect(result.tournament['expectedPlayers'], equals(8));
      });

      test('Round 1 に 4 マッチ生成される。', () {
        final result = generator.generate();

        final round1 = result.rounds[0];
        expect(round1.matches.length, equals(4));
        expect(round1.data['status'], equals('COMPLETED'));
      });

      test('Round 2 に 4 マッチ生成される。', () {
        final result = generator.generate();

        final round2 = result.rounds[1];
        expect(round2.matches.length, equals(4));
        expect(round2.data['status'], equals('IN_PROGRESS'));
      });

      test('生成されたデータが検証をパスする。', () {
        final result = generator.generate();
        final validation = result.validate();

        expect(validation.isValid, isTrue);
        expect(validation.errors, isEmpty);
      });
    });

    group('generateTournamentId メソッドのテスト。', () {
      test('正しいトーナメント ID を返す。', () {
        final result = generator.generateTournamentId();

        expect(result, equals('test-tournament-small-001'));
      });
    });

    group('generatePlayerId メソッドのテスト。', () {
      test('インデックス 0 で正しいプレイヤー ID を生成する。', () {
        final result = generator.generatePlayerId(0);

        expect(result, equals('test-player-001'));
      });

      test('インデックス 9 で正しいプレイヤー ID を生成する。', () {
        final result = generator.generatePlayerId(9);

        expect(result, equals('test-player-010'));
      });

      test('インデックス 99 で正しいプレイヤー ID を生成する。', () {
        final result = generator.generatePlayerId(99);

        expect(result, equals('test-player-100'));
      });
    });

    group('generateUserId メソッドのテスト。', () {
      test('インデックス 0 で正しいユーザー ID を生成する。', () {
        final result = generator.generateUserId(0);

        expect(result, equals('test-user-001'));
      });

      test('インデックス 7 で正しいユーザー ID を生成する。', () {
        final result = generator.generateUserId(7);

        expect(result, equals('test-user-008'));
      });
    });

    group('generateMatchId メソッドのテスト。', () {
      test('ラウンド 1、マッチ 1 で正しいマッチ ID を生成する。', () {
        final result = generator.generateMatchId(1, 1);

        expect(result, equals('match-round1-1'));
      });

      test('ラウンド 2、マッチ 4 で正しいマッチ ID を生成する。', () {
        final result = generator.generateMatchId(2, 4);

        expect(result, equals('match-round2-4'));
      });
    });

    group('generateRoundId メソッドのテスト。', () {
      test('ラウンド番号 1 で正しいラウンド ID を生成する。', () {
        final result = generator.generateRoundId(1);

        expect(result, equals('round1'));
      });

      test('ラウンド番号 3 で正しいラウンド ID を生成する。', () {
        final result = generator.generateRoundId(3);

        expect(result, equals('round3'));
      });
    });

    group('generateTimestamp メソッドのテスト。', () {
      test('オフセットなしで ISO8601 形式のタイムスタンプを生成する。', () {
        final result = generator.generateTimestamp();

        // ISO8601 形式かどうかを確認する。
        expect(result, matches(r'\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}'));
      });

      test('日数オフセットありでタイムスタンプを生成する。', () {
        final result = generator.generateTimestamp(offsetDays: 1);

        // ISO8601 形式かどうかを確認する。
        expect(result, matches(r'\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}'));
      });

      test('時間オフセットありでタイムスタンプを生成する。', () {
        final result = generator.generateTimestamp(offsetHours: 2);

        // ISO8601 形式かどうかを確認する。
        expect(result, matches(r'\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}'));
      });

      test('両方のオフセットありでタイムスタンプを生成する。', () {
        final result =
            generator.generateTimestamp(offsetDays: 1, offsetHours: 2);

        // ISO8601 形式かどうかを確認する。
        expect(result, matches(r'\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}'));
      });
    });

    group('データ整合性のテスト。', () {
      test('すべてのプレイヤーに一意の ID が割り当てられる。', () {
        final result = generator.generate();
        final playerIds = result.players.map((p) => p.id).toList();

        expect(playerIds.toSet().length, equals(playerIds.length));
      });

      test('すべてのプレイヤーに一意のユーザー ID が割り当てられる。', () {
        final result = generator.generate();
        final userIds =
            result.players.map((p) => p.data['userId']).toList();

        expect(userIds.toSet().length, equals(userIds.length));
      });

      test('すべてのマッチに一意の ID が割り当てられる。', () {
        final result = generator.generate();
        final matchIds = <String>[];

        for (final round in result.rounds) {
          for (final match in round.matches) {
            matchIds.add(match.id);
          }
        }

        expect(matchIds.toSet().length, equals(matchIds.length));
      });

      test('Round 1 のすべてのマッチに結果が入力されている。', () {
        final result = generator.generate();
        final round1 = result.rounds[0];

        for (final match in round1.matches) {
          expect(match.data['result'], isNotNull);
        }
      });

      test('Round 2 に未入力のマッチと入力済みのマッチが混在する。', () {
        final result = generator.generate();
        final round2 = result.rounds[1];

        final hasNullResult =
            round2.matches.any((m) => m.data['result'] == null);
        final hasFilledResult =
            round2.matches.any((m) => m.data['result'] != null);

        expect(hasNullResult, isTrue);
        expect(hasFilledResult, isTrue);
      });
    });
  });
}
