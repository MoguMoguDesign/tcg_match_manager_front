/// 参加者データクラス
class ParticipantData {
  /// 参加者データのコンストラクタ
  const ParticipantData({
    required this.id,
    required this.name,
    required this.tournamentId,
    this.registeredAt,
    this.isParticipating = true,
  });

  /// 参加者ID
  final String id;

  /// 参加者名
  final String name;

  /// トーナメントID
  final String tournamentId;

  /// 登録日時
  final DateTime? registeredAt;

  /// 参加状況（true: 参加中, false: ドロップ）
  final bool isParticipating;

  /// コピーメソッド
  ParticipantData copyWith({
    String? id,
    String? name,
    String? tournamentId,
    DateTime? registeredAt,
    bool? isParticipating,
  }) {
    return ParticipantData(
      id: id ?? this.id,
      name: name ?? this.name,
      tournamentId: tournamentId ?? this.tournamentId,
      registeredAt: registeredAt ?? this.registeredAt,
      isParticipating: isParticipating ?? this.isParticipating,
    );
  }
}
