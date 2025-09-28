// テストデータとしてダミーデータの英語使用を許可
// ignore_for_file: avoid_hardcoded_japanese

/// トーナメント情報を表すデータクラス。
///
/// トーナメントのタイトル、開催日、参加者数の情報を保持する。
class MockTournament {
  /// [MockTournament]のコンストラクタ。
  ///
  /// [title]、[date]、[participantCount]はすべて必須パラメータ。
  const MockTournament({
    required this.title,
    required this.date,
    required this.participantCount,
  });

  /// トーナメントのタイトル。
  final String title;

  /// トーナメントの開催日（YYYY/MM/DD形式）。
  final String date;

  /// トーナメントの参加者数。
  final int participantCount;
}

/// プレイヤー情報を表すデータクラス。
///
/// プレイヤーの名前、現在のスコア、現在のユーザーかどうかの情報を保持する。
class Player {
  /// [Player]のコンストラクタ。
  ///
  /// [name]と[score]は必須パラメータ。
  /// [isCurrentPlayer]はオプションでデフォルトは`false`。
  const Player({
    required this.name,
    required this.score,
    this.isCurrentPlayer = false,
  });

  /// プレイヤーの名前。
  final String name;

  /// プレイヤーの現在のスコア。
  final int score;

  /// このプレイヤーが現在のユーザーかどうか。
  final bool isCurrentPlayer;
}

/// 対戦情報を表すデータクラス。
///
/// テーブル番号、対戦する2人のプレイヤー、試合状況、勝者の情報を保持する。
class Match {
  /// [Match]のコンストラクタ。
  ///
  /// [tableNumber]、[player1]、[player2]、[status]は必須パラメータ。
  /// [winner]はオプションで、試合完了時にのみ設定される。
  const Match({
    required this.tableNumber,
    required this.player1,
    required this.player2,
    required this.status,
    this.winner,
  });

  /// 対戦が行われるテーブル番号。
  final int tableNumber;

  /// 1人目のプレイヤー。
  final Player player1;

  /// 2人目のプレイヤー。
  final Player player2;

  /// 対戦の現在の状況。
  final MatchStatus status;

  /// 対戦の勝者（試合が完了している場合のみ）。
  final Player? winner;
}

/// 対戦の状況を表す列挙型。
enum MatchStatus {
  /// 試合進行中。
  ongoing,

  /// 試合完了。
  completed,
}

/// モック用のテストデータを提供するクラス。
///
/// UI開発とテスト用に、トーナメント、プレイヤー、対戦のサンプルデータを定義する。
class MockData {
  /// サンプルのトーナメント情報。
  static const MockTournament tournament = MockTournament(
    title: 'トーナメントタイトル',
    date: '2025/08/31',
    participantCount: 32,
  );

  /// サンプルのプレイヤー一覧。
  /// 現在のユーザーを含む8名のプレイヤーデータ。
  static const List<Player> players = [
    Player(name: 'プレイヤー1', score: 0),
    Player(name: 'プレイヤー2', score: 0),
    Player(name: 'プレイヤー自身', score: 0, isCurrentPlayer: true),
    Player(name: 'プレイヤー4', score: 0),
    Player(name: 'プレイヤー5', score: 0),
    Player(name: 'プレイヤー6', score: 0),
    Player(name: 'プレイヤー7', score: 0),
    Player(name: 'プレイヤー8', score: 0),
  ];

  /// 指定されたラウンドの対戦データを取得する。
  ///
  /// [round]に応じて、そのラウンドの対戦組み合わせとステータスを返す。
  /// 現在はラウンド1のみに対応しており、それ以外は空のリストを返す。
  static List<Match> getRoundMatches(int round) {
    switch (round) {
      case 1:
        return [
          Match(
            tableNumber: 1,
            player1: players[0],
            player2: players[2],
            status: MatchStatus.ongoing,
          ),
          Match(
            tableNumber: 2,
            player1: players[1],
            player2: players[3],
            status: MatchStatus.ongoing,
          ),
          Match(
            tableNumber: 3,
            player1: players[4],
            player2: players[5],
            status: MatchStatus.completed,
            winner: players[4],
          ),
          Match(
            tableNumber: 4,
            player1: players[6],
            player2: players[7],
            status: MatchStatus.completed,
            winner: players[7],
          ),
        ];
      default:
        return [];
    }
  }
}
