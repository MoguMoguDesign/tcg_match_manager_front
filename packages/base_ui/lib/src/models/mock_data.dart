/// プレイヤーの情報を表すデータクラス。
/// 
/// 名前、スコア、現在のユーザーかどうかの情報を保持する。
class Player {
  /// [Player]のコンストラクタ。
  /// 
  /// [name]、[score]、[isCurrentPlayer]はすべて必須パラメータ。
  const Player({
    required this.name,
    required this.score,
    required this.isCurrentPlayer,
  });

  /// プレイヤーの名前。
  final String name;

  /// プレイヤーの累計得点。
  final int score;

  /// このプレイヤーが現在のユーザーかどうか。
  final bool isCurrentPlayer;
}

/// マッチの状態を表す列挙型。
/// 
/// 進行中と完了の2つの状態を定義する。
enum MatchStatus {
  /// マッチが進行中の状態。
  ongoing,
  
  /// マッチが完了した状態。
  completed,
}

/// マッチの情報を表すデータクラス。
/// 
/// テーブル番号、参加プレイヤー、状態、勝者の情報を保持する。
class Match {
  /// [Match]のコンストラクタ。
  /// 
  /// [tableNumber]、[player1]、[player2]、[status]は必須パラメータ。
  /// [winner]はマッチ完了時のみ設定される。
  const Match({
    required this.tableNumber,
    required this.player1,
    required this.player2,
    required this.status,
    this.winner,
  });

  /// テーブル番号。
  final int tableNumber;

  /// プレイヤー1の情報。
  final Player player1;

  /// プレイヤー2の情報。
  final Player player2;

  /// マッチの現在状態。
  final MatchStatus status;

  /// 勝者のプレイヤー情報。
  /// マッチが完了していない場合はnull。
  final Player? winner;
}

/// トーナメント情報を表すデータクラス。
/// 
/// トーナメントのタイトル、開催日、参加者数の情報を保持する。
class Tournament {
  /// [Tournament]のコンストラクタ。
  /// 
  /// [title]、[date]、[participantCount]はすべて必須パラメータ。
  const Tournament({
    required this.title,
    required this.date,
    required this.participantCount,
  });

  /// トーナメントのタイトル。
  final String title;

  /// 開催日の文字列表現。
  final String date;

  /// 参加者数。
  final int participantCount;
}

/// 開発・テスト用のモックデータを提供するクラス。
/// 
/// サンプルのプレイヤー、マッチ、トーナメントデータを提供する。
class MockData {
  /// サンプルプレイヤーのリスト。
  static const List<Player> players = [
    Player(
      name: 'プレイヤー1',
      score: 1200,
      isCurrentPlayer: true,
    ),
    Player(
      name: 'プレイヤー2',
      score: 1100,
      isCurrentPlayer: false,
    ),
    Player(
      name: 'プレイヤー3',
      score: 1300,
      isCurrentPlayer: false,
    ),
    Player(
      name: 'プレイヤー4',
      score: 1000,
      isCurrentPlayer: false,
    ),
  ];

  /// サンプルマッチのリスト。
  static final List<Match> matches = [
    const Match(
      tableNumber: 1,
      player1: Player(
        name: 'プレイヤー1',
        score: 1200,
        isCurrentPlayer: true,
      ),
      player2: Player(
        name: 'プレイヤー2',
        score: 1100,
        isCurrentPlayer: false,
      ),
      status: MatchStatus.ongoing,
    ),
    const Match(
      tableNumber: 2,
      player1: Player(
        name: 'プレイヤー3',
        score: 1300,
        isCurrentPlayer: false,
      ),
      player2: Player(
        name: 'プレイヤー4',
        score: 1000,
        isCurrentPlayer: false,
      ),
      status: MatchStatus.completed,
      winner: Player(
        name: 'プレイヤー3',
        score: 1300,
        isCurrentPlayer: false,
      ),
    ),
  ];

  /// サンプルトーナメントのリスト。
  static const List<Tournament> tournaments = [
    Tournament(
      title: '第1回TCGトーナメント',
      date: '2024-01-15',
      participantCount: 32,
    ),
    Tournament(
      title: '第2回TCGトーナメント', 
      date: '2024-02-20',
      participantCount: 24,
    ),
  ];
}
