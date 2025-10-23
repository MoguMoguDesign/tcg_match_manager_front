import 'dart:convert';

import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:repository/repository.dart';
import 'package:riverpod/riverpod.dart';

import 'player_session_notifier_test.mocks.dart';

// LocalConfigRepository のモッククラスを生成する。
@GenerateNiceMocks([MockSpec<LocalConfigRepository>()])
void main() {
  late MockLocalConfigRepository mockLocalConfigRepository;
  late ProviderContainer container;

  setUp(() {
    mockLocalConfigRepository = MockLocalConfigRepository();
    container = ProviderContainer(
      overrides: [
        localConfigRepositoryProvider.overrideWithValue(
          mockLocalConfigRepository,
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('playerSessionNotifierProvider のテスト。', () {
    test('playerSessionNotifierProvider が PlayerSessionNotifier を返す。', () {
      // デフォルト値を返すスタブを用意する。
      when(
        mockLocalConfigRepository.getString(
          key: anyNamed('key'),
        ),
      ).thenReturn(null);

      expect(
        container.read(playerSessionNotifierProvider.notifier),
        isA<PlayerSessionNotifier>(),
      );
    });
  });

  group('PlayerSessionNotifier のテスト。', () {
    group('build メソッドのテスト。', () {
      test('リポジトリから取得したデータで PlayerSession を生成する。', () {
        final testSession = PlayerSession(
          playerId: 'player123',
          playerNumber: 5,
          userId: 'user456',
          tournamentId: 'tournament789',
          playerName: 'テストプレイヤー',
          createdAt: DateTime(2025, 10, 4, 12, 0, 0),
          expiresAt: DateTime(2025, 10, 5, 12, 0, 0),
        );

        // getString メソッドが指定された値を返すスタブを用意する。
        when(
          mockLocalConfigRepository.getString(
            key: LocalConfigKey.playerSession,
          ),
        ).thenReturn(jsonEncode(testSession.toJson()));

        // state を取得し、期待する値が設定されていることを確認する。
        final state = container.read(playerSessionNotifierProvider);

        expect(state, isA<PlayerSession>());
        expect(state.playerId, 'player123');
        expect(state.playerNumber, 5);
        expect(state.userId, 'user456');
        expect(state.tournamentId, 'tournament789');
        expect(state.playerName, 'テストプレイヤー');

        // リポジトリのメソッドが正しい引数で呼び出されることを確認する。
        verify(
          mockLocalConfigRepository.getString(
            key: LocalConfigKey.playerSession,
          ),
        ).called(1);
      });

      test('リポジトリから値が取得できない場合、デフォルト値で PlayerSession を生成する。', () {
        // getString メソッドが null を返すスタブを用意する。
        when(
          mockLocalConfigRepository.getString(
            key: LocalConfigKey.playerSession,
          ),
        ).thenReturn(null);

        // state を取得し、デフォルト値が設定されていることを確認する。
        final state = container.read(playerSessionNotifierProvider);

        expect(state, isA<PlayerSession>());
        expect(state.playerId, PlayerSession.playerIdDefault);
        expect(state.playerNumber, PlayerSession.playerNumberDefault);
        expect(state.userId, PlayerSession.userIdDefault);
      });
    });

    group('saveSession メソッドのテスト。', () {
      test('セッション情報を正常に保存し、state に反映される。', () async {
        final initialSession = PlayerSession(
          playerId: PlayerSession.playerIdDefault,
          playerNumber: PlayerSession.playerNumberDefault,
          userId: PlayerSession.userIdDefault,
          tournamentId: PlayerSession.tournamentIdDefault,
          playerName: PlayerSession.playerNameDefault,
          createdAt: DateTime.now(),
          expiresAt: DateTime.now(),
        );

        final newSession = PlayerSession(
          playerId: 'player123',
          playerNumber: 5,
          userId: 'user456',
          tournamentId: 'tournament789',
          playerName: 'テストプレイヤー',
          createdAt: DateTime(2025, 10, 4, 12, 0, 0),
          expiresAt: DateTime(2025, 10, 5, 12, 0, 0),
        );

        // 初期値を返すスタブを用意する。
        when(
          mockLocalConfigRepository.getString(
            key: LocalConfigKey.playerSession,
          ),
        ).thenReturn(null);

        // setString メソッドが正常に完了するスタブを用意する。
        when(
          mockLocalConfigRepository.setString(
            key: LocalConfigKey.playerSession,
            value: anyNamed('value'),
          ),
        ).thenAnswer((_) async => Future<void>.value());

        final notifier = container.read(playerSessionNotifierProvider.notifier);

        // 初期 state を確認する。
        var state = container.read(playerSessionNotifierProvider);
        expect(state.playerId, PlayerSession.playerIdDefault);

        // saveSession メソッドを実行する。
        await notifier.saveSession(newSession);

        // state が更新されていることを確認する。
        state = container.read(playerSessionNotifierProvider);
        expect(state.playerId, 'player123');
        expect(state.playerNumber, 5);
        expect(state.userId, 'user456');
        expect(state.tournamentId, 'tournament789');
        expect(state.playerName, 'テストプレイヤー');

        // リポジトリの setString メソッドが正しい引数で呼び出されることを確認する。
        verify(
          mockLocalConfigRepository.setString(
            key: LocalConfigKey.playerSession,
            value: jsonEncode(newSession.toJson()),
          ),
        ).called(1);
      });
    });

    group('clearSession メソッドのテスト。', () {
      test('セッション情報をクリアし、state がデフォルト値になる。', () async {
        final testSession = PlayerSession(
          playerId: 'player123',
          playerNumber: 5,
          userId: 'user456',
          tournamentId: 'tournament789',
          playerName: 'テストプレイヤー',
          createdAt: DateTime(2025, 10, 4, 12, 0, 0),
          expiresAt: DateTime(2025, 10, 5, 12, 0, 0),
        );

        // 初期値を返すスタブを用意する。
        when(
          mockLocalConfigRepository.getString(
            key: LocalConfigKey.playerSession,
          ),
        ).thenReturn(jsonEncode(testSession.toJson()));

        // setString メソッドが正常に完了するスタブを用意する。
        when(
          mockLocalConfigRepository.setString(
            key: LocalConfigKey.playerSession,
            value: anyNamed('value'),
          ),
        ).thenAnswer((_) async => Future<void>.value());

        final notifier = container.read(playerSessionNotifierProvider.notifier);

        // 初期 state を確認する。
        var state = container.read(playerSessionNotifierProvider);
        expect(state.playerId, 'player123');

        // clearSession メソッドを実行する。
        await notifier.clearSession();

        // state がデフォルト値になっていることを確認する。
        state = container.read(playerSessionNotifierProvider);
        expect(state.playerId, PlayerSession.playerIdDefault);
        expect(state.playerNumber, PlayerSession.playerNumberDefault);
        expect(state.userId, PlayerSession.userIdDefault);
      });
    });

    group('isSessionValid メソッドのテスト。', () {
      test('セッションが有効な場合、true を返す。', () {
        final validSession = PlayerSession(
          playerId: 'player123',
          playerNumber: 5,
          userId: 'user456',
          tournamentId: 'tournament789',
          playerName: 'テストプレイヤー',
          createdAt: DateTime.now(),
          expiresAt: DateTime.now().add(const Duration(hours: 1)),
        );

        // 有効なセッションを返すスタブを用意する。
        when(
          mockLocalConfigRepository.getString(
            key: LocalConfigKey.playerSession,
          ),
        ).thenReturn(jsonEncode(validSession.toJson()));

        final notifier = container.read(playerSessionNotifierProvider.notifier);

        // isSessionValid メソッドが true を返すことを確認する。
        expect(notifier.isSessionValid(), isTrue);
      });

      test('セッションが期限切れの場合、false を返す。', () {
        final expiredSession = PlayerSession(
          playerId: 'player123',
          playerNumber: 5,
          userId: 'user456',
          tournamentId: 'tournament789',
          playerName: 'テストプレイヤー',
          createdAt: DateTime.now().subtract(const Duration(hours: 25)),
          expiresAt: DateTime.now().subtract(const Duration(hours: 1)),
        );

        // 期限切れのセッションを返すスタブを用意する。
        when(
          mockLocalConfigRepository.getString(
            key: LocalConfigKey.playerSession,
          ),
        ).thenReturn(jsonEncode(expiredSession.toJson()));

        final notifier = container.read(playerSessionNotifierProvider.notifier);

        // isSessionValid メソッドが false を返すことを確認する。
        expect(notifier.isSessionValid(), isFalse);
      });

      test('セッションが存在しない場合、false を返す。', () {
        // セッションが存在しないスタブを用意する。
        when(
          mockLocalConfigRepository.getString(
            key: LocalConfigKey.playerSession,
          ),
        ).thenReturn(null);

        final notifier = container.read(playerSessionNotifierProvider.notifier);

        // isSessionValid メソッドが false を返すことを確認する。
        expect(notifier.isSessionValid(), isFalse);
      });
    });
  });
}
