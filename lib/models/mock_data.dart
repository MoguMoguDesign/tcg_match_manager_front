class Tournament {
  final String title;
  final String date;
  final int participantCount;
  
  const Tournament({
    required this.title,
    required this.date,
    required this.participantCount,
  });
}

class Player {
  final String name;
  final int score;
  final bool isCurrentPlayer;
  
  const Player({
    required this.name,
    required this.score,
    this.isCurrentPlayer = false,
  });
}

class Match {
  final int tableNumber;
  final Player player1;
  final Player player2;
  final MatchStatus status;
  final Player? winner;
  
  const Match({
    required this.tableNumber,
    required this.player1,
    required this.player2,
    required this.status,
    this.winner,
  });
}

enum MatchStatus { ongoing, completed }

class MockData {
  static const Tournament tournament = Tournament(
    title: 'トーナメントタイトル',
    date: '2025/08/31',
    participantCount: 32,
  );
  
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