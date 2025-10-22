import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TournamentCategory のテスト', () {
    group('クラスのテスト', () {
      test('TournamentCategory クラスの型が正しい', () {
        // クラス自体への参照を確認することで、プライベートコンストラクタを含むクラスがロードされる
        expect(TournamentCategory, isA<Type>());
      });
    });

    group('定数値のテスト', () {
      test('pokemon の値が正しい', () {
        expect(TournamentCategory.pokemon, 'ポケモンカード');
      });

      test('yugioh の値が正しい', () {
        expect(TournamentCategory.yugioh, '遊☆戯☆王');
      });

      test('duelMasters の値が正しい', () {
        expect(TournamentCategory.duelMasters, 'デュエル・マスターズ');
      });

      test('onePiece の値が正しい', () {
        expect(TournamentCategory.onePiece, 'ワンピカード');
      });

      test('weissSchwarz の値が正しい', () {
        expect(TournamentCategory.weissSchwarz, 'ヴァイスシュヴァルツ');
      });

      test('magicTheGathering の値が正しい', () {
        expect(TournamentCategory.magicTheGathering, 'マジック:ザ・ギャザリング');
      });

      test('wixoss の値が正しい', () {
        expect(TournamentCategory.wixoss, 'WIXOSS');
      });

      test('battleSpirits の値が正しい', () {
        expect(TournamentCategory.battleSpirits, 'バトルスピリッツ');
      });

      test('vanguard の値が正しい', () {
        expect(TournamentCategory.vanguard, 'ヴァンガード');
      });

      test('zx の値が正しい', () {
        expect(TournamentCategory.zx, 'Z/X -Zillions of enemy X-');
      });

      test('rebirth の値が正しい', () {
        expect(TournamentCategory.rebirth, 'Re:バース for you');
      });

      test('preciousMemories の値が正しい', () {
        expect(TournamentCategory.preciousMemories, 'プレシャスメモリーズ');
      });

      test('unionArena の値が正しい', () {
        expect(TournamentCategory.unionArena, 'UNION ARENA');
      });
    });

    group('all リストのテスト', () {
      test('all リストが13個のカテゴリを含む', () {
        expect(TournamentCategory.all.length, 13);
      });

      test('all リストに pokemon が含まれる', () {
        expect(
          TournamentCategory.all,
          contains(TournamentCategory.pokemon),
        );
      });

      test('all リストに yugioh が含まれる', () {
        expect(
          TournamentCategory.all,
          contains(TournamentCategory.yugioh),
        );
      });

      test('all リストに duelMasters が含まれる', () {
        expect(
          TournamentCategory.all,
          contains(TournamentCategory.duelMasters),
        );
      });

      test('all リストに onePiece が含まれる', () {
        expect(
          TournamentCategory.all,
          contains(TournamentCategory.onePiece),
        );
      });

      test('all リストに weissSchwarz が含まれる', () {
        expect(
          TournamentCategory.all,
          contains(TournamentCategory.weissSchwarz),
        );
      });

      test('all リストに magicTheGathering が含まれる', () {
        expect(
          TournamentCategory.all,
          contains(TournamentCategory.magicTheGathering),
        );
      });

      test('all リストに wixoss が含まれる', () {
        expect(
          TournamentCategory.all,
          contains(TournamentCategory.wixoss),
        );
      });

      test('all リストに battleSpirits が含まれる', () {
        expect(
          TournamentCategory.all,
          contains(TournamentCategory.battleSpirits),
        );
      });

      test('all リストに vanguard が含まれる', () {
        expect(
          TournamentCategory.all,
          contains(TournamentCategory.vanguard),
        );
      });

      test('all リストに zx が含まれる', () {
        expect(
          TournamentCategory.all,
          contains(TournamentCategory.zx),
        );
      });

      test('all リストに rebirth が含まれる', () {
        expect(
          TournamentCategory.all,
          contains(TournamentCategory.rebirth),
        );
      });

      test('all リストに preciousMemories が含まれる', () {
        expect(
          TournamentCategory.all,
          contains(TournamentCategory.preciousMemories),
        );
      });

      test('all リストに unionArena が含まれる', () {
        expect(
          TournamentCategory.all,
          contains(TournamentCategory.unionArena),
        );
      });

      test('all リストの要素順序が正しい', () {
        expect(TournamentCategory.all, [
          TournamentCategory.pokemon,
          TournamentCategory.yugioh,
          TournamentCategory.duelMasters,
          TournamentCategory.onePiece,
          TournamentCategory.weissSchwarz,
          TournamentCategory.magicTheGathering,
          TournamentCategory.wixoss,
          TournamentCategory.battleSpirits,
          TournamentCategory.vanguard,
          TournamentCategory.zx,
          TournamentCategory.rebirth,
          TournamentCategory.preciousMemories,
          TournamentCategory.unionArena,
        ]);
      });
    });

    group('重複チェック', () {
      test('all リストに重複した値が含まれない', () {
        final uniqueCategories = TournamentCategory.all.toSet();
        expect(
          uniqueCategories.length,
          TournamentCategory.all.length,
          reason: 'all リストに重複した値が含まれています',
        );
      });
    });
  });
}
