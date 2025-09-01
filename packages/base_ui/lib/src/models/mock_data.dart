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

/// ランキング表示用のプレイヤー情報を表すデータクラス。
/// 
/// 順位、名前、スコア、OMWパーセンテージ、現在のユーザーかどうかの情報を保持する。
class RankingPlayer {
  /// [RankingPlayer]のコンストラクタ。
  /// 
  /// [rank]、[name]、[score]、[omwPercentage]は必須パラメータ。
  /// [isCurrentPlayer]はオプションでデフォルトはfalse。
  const RankingPlayer({
    required this.rank,
    required this.name,
    required this.score,
    required this.omwPercentage,
    this.isCurrentPlayer = false,
  });

  /// プレイヤーの順位。
  final int rank;
  
  /// プレイヤーの名前。
  final String name;
  
  /// プレイヤーの現在のスコア。
  final int score;
  
  /// プレイヤーのOMW（Opponent Match Win）パーセンテージ。
  final double omwPercentage;
  
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
/// トーナメントのタイトル、開催日、参加者数、現在ラウンド情報を保持する。
class Tournament {
  /// [Tournament]のコンストラクタ。
  /// 
  /// [title]、[date]、[participantCount]は必須パラメータ。
  /// [currentRound]と[totalRounds]はデフォルト値を持つ。
  const Tournament({
    required this.title,
    required this.date,
    required this.participantCount,
    this.currentRound = 1,
    this.totalRounds = 4,
  });

  /// トーナメントのタイトル。
  final String title;

  /// 開催日の文字列表現。
  final String date;

  /// 参加者数。
  final int participantCount;

  /// 現在のラウンド番号。
  final int currentRound;

  /// 総ラウンド数。
  final int totalRounds;

  /// 最終ラウンド終了かどうか。
  bool get isFinalRoundComplete => currentRound > totalRounds;

  /// 次のラウンドに進むコピーを作成する。
  Tournament nextRound() {
    return Tournament(
      title: title,
      date: date,
      participantCount: participantCount,
      currentRound: currentRound + 1,
      totalRounds: totalRounds,
    );
  }
}

/// 開発・テスト用のモックデータを提供するクラス。
/// 
/// サンプルのプレイヤー、マッチ、トーナメントデータを提供する。
class MockData {
  /// サンプルプレイヤーのリスト（16人制対応）。
  static const List<Player> players = [
    Player(name: 'プレイヤー1', score: 12, isCurrentPlayer: true),
    Player(name: 'プレイヤー2', score: 9, isCurrentPlayer: false),
    Player(name: 'プレイヤー3', score: 9, isCurrentPlayer: false),
    Player(name: 'プレイヤー4', score: 9, isCurrentPlayer: false),
    Player(name: 'プレイヤー5', score: 6, isCurrentPlayer: false),
    Player(name: 'プレイヤー6', score: 6, isCurrentPlayer: false),
    Player(name: 'プレイヤー7', score: 6, isCurrentPlayer: false),
    Player(name: 'プレイヤー8', score: 6, isCurrentPlayer: false),
    Player(name: 'プレイヤー9', score: 6, isCurrentPlayer: false),
    Player(name: 'プレイヤー10', score: 6, isCurrentPlayer: false),
    Player(name: 'プレイヤー11', score: 3, isCurrentPlayer: false),
    Player(name: 'プレイヤー12', score: 3, isCurrentPlayer: false),
    Player(name: 'プレイヤー13', score: 3, isCurrentPlayer: false),
    Player(name: 'プレイヤー14', score: 3, isCurrentPlayer: false),
    Player(name: 'プレイヤー15', score: 0, isCurrentPlayer: false),
    Player(name: 'プレイヤー16', score: 0, isCurrentPlayer: false),
  ];

  /// 第5ラウンド（4ラウンド終了後）の仮想マッチリスト。
  /// 実際の実装では最終順位表に遷移する。
  static final List<Match> matches = [
    Match(
      tableNumber: 1,
      player1: players[0], // プレイヤー1 (12点)
      player2: players[1], // プレイヤー2 (9点)
      status: MatchStatus.completed,
      winner: players[0],
    ),
    Match(
      tableNumber: 2,
      player1: players[2], // プレイヤー3 (9点)
      player2: players[3], // プレイヤー4 (9点)
      status: MatchStatus.completed,
      winner: players[2],
    ),
    Match(
      tableNumber: 3,
      player1: players[4], // プレイヤー5 (6点)
      player2: players[5], // プレイヤー6 (6点)
      status: MatchStatus.completed,
      winner: players[4],
    ),
    Match(
      tableNumber: 4,
      player1: players[6], // プレイヤー7 (6点)
      player2: players[7], // プレイヤー8 (6点)
      status: MatchStatus.completed,
      winner: players[6],
    ),
    Match(
      tableNumber: 5,
      player1: players[8], // プレイヤー9 (6点)
      player2: players[9], // プレイヤー10 (6点)
      status: MatchStatus.completed,
      winner: players[8],
    ),
    Match(
      tableNumber: 6,
      player1: players[10], // プレイヤー11 (3点)
      player2: players[11], // プレイヤー12 (3点)
      status: MatchStatus.completed,
      winner: players[10],
    ),
    Match(
      tableNumber: 7,
      player1: players[12], // プレイヤー13 (3点)
      player2: players[13], // プレイヤー14 (3点)
      status: MatchStatus.completed,
      winner: players[12],
    ),
    Match(
      tableNumber: 8,
      player1: players[14], // プレイヤー15 (0点)
      player2: players[15], // プレイヤー16 (0点)
      status: MatchStatus.completed,
      winner: players[14],
    ),
  ];

  /// サンプルトーナメントのリスト。
  static const List<Tournament> tournaments = [
    Tournament(
      title: '第1回TCGトーナメント',
      date: '2024-01-15',
      participantCount: 16,
      currentRound: 1,
      totalRounds: 4,
    ),
    Tournament(
      title: '第2回TCGトーナメント', 
      date: '2024-02-20',
      participantCount: 16,
      currentRound: 3,
      totalRounds: 4,
    ),
  ];
  
  /// デフォルトのサンプルトーナメント（4ラウンド終了後）。
  static const Tournament tournament = Tournament(
    title: 'トーナメントタイトル',
    date: '2025/08/31',
    participantCount: 16,
    currentRound: 5, // 4ラウンド終了後（5ラウンド目 = 最終順位表表示）
    totalRounds: 4,
  );
  
  /// 現在のトーナメント状況を管理する変数。
  /// 実際のアプリでは状態管理（Riverpod等）で管理される。
  static Tournament currentTournament = tournament;

  /// 指定されたラウンドのマッチリストを取得する。
  static List<Match> getRoundMatches(int round) {
    // 4ラウンド終了後（round > 4）は最終順位表に遷移すべき
    if (round > currentTournament.totalRounds) {
      return []; // 空のリストを返してマッチなしを示す
    }
    
    // 各ラウンドの仮想マッチデータを生成
    // 実際の実装では、ラウンド進行に応じて動的に生成される
    return List.generate(8, (index) {
      final player1Index = (index * 2) % players.length;
      final player2Index = (index * 2 + 1) % players.length;
      
      return Match(
        tableNumber: index + 1,
        player1: players[player1Index],
        player2: players[player2Index],
        status: round <= currentTournament.currentRound - 1 
            ? MatchStatus.completed
            : MatchStatus.ongoing,
        winner: round <= currentTournament.currentRound - 1
            ? (players[player1Index].score >= players[player2Index].score 
               ? players[player1Index] 
               : players[player2Index])
            : null,
      );
    });
  }

  /// 次のラウンドに進む。
  static void nextRound() {
    currentTournament = currentTournament.nextRound();
  }

  /// 最終ラウンド終了後かどうかを判定する。
  static bool get isTournamentComplete => 
      currentTournament.isFinalRoundComplete;

  /// 最終順位用にソートされたランキングプレイヤーリストを取得する。
  static List<RankingPlayer> get finalRanking {
    final sortedPlayers = List<Player>.from(players);
    // スコア降順でソート（同点の場合は名前順）
    sortedPlayers.sort((Player a, Player b) {
      final scoreCompare = b.score.compareTo(a.score);
      return scoreCompare != 0 ? scoreCompare : a.name.compareTo(b.name);
    });
    
    // ランクを付けてRankingPlayerに変換
    return sortedPlayers.asMap().entries.map((entry) {
      final index = entry.key;
      final Player player = entry.value;
      return RankingPlayer(
        rank: index + 1,
        name: player.name,
        score: player.score,
        omwPercentage: _calculateOMW(player), // 仮のOMW計算
        isCurrentPlayer: player.isCurrentPlayer,
      );
    }).toList();
  }
  
  /// プレイヤーのOMW（Opponent Match Win）パーセンテージを計算する。
  /// 実際の実装では対戦相手の勝率から算出される。
  static double _calculateOMW(Player player) {
    // 仮の計算：スコアに基づいてOMWを推定
    const maxScore = 12; // 4ラウンド × 3点
    final omwBase = (player.score / maxScore) * 100;
    // ランダム性を加えて現実的な値に
    final variation = (player.name.hashCode % 20) - 10; // -10から+10の範囲
    return (omwBase + variation).clamp(0.0, 100.0);
  }
}
