import 'package:base_ui/base_ui.dart';
import 'package:flutter/material.dart';

import '../../models/participant_data.dart';

/// 参加者ステータス変更のコールバック型
typedef OnParticipantStatusChanged =
    void Function(String participantId, {required bool isParticipating});

/// 参加者削除のコールバック型
typedef OnParticipantDelete = void Function(ParticipantData participant);

/// 参加者名変更のコールバック型
typedef OnParticipantNameChanged =
    void Function(String participantId, String newName);

/// 参加者一覧テーブル
class ParticipantTable extends StatelessWidget {
  /// 参加者テーブルのコンストラクタ
  const ParticipantTable({
    required this.participants,
    required this.participantStatus,
    required this.nameControllers,
    required this.onStatusChanged,
    required this.onDelete,
    this.showStatus = true,
    this.showRegistrationDate = false,
    super.key,
  });

  /// 参加者リスト
  final List<ParticipantData> participants;

  /// 参加者のステータス（参加中/ドロップ）
  final Map<String, bool> participantStatus;

  /// 名前入力のコントローラー
  final Map<String, TextEditingController> nameControllers;

  /// ステータス変更時のコールバック
  final OnParticipantStatusChanged onStatusChanged;

  /// 削除時のコールバック
  final OnParticipantDelete onDelete;

  /// ステータス列を表示するかどうか
  final bool showStatus;

  /// 登録日時を表示するかどうか
  final bool showRegistrationDate;

  @override
  Widget build(BuildContext context) {
    if (participants.isEmpty) {
      return Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderGray),
        ),
        child: const Center(
          child: Text(
            '参加者がいません',
            style: TextStyle(fontSize: 16, color: AppColors.grayDark),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderGray),
      ),
      child: Column(
        children: [
          // ヘッダー
          _buildTableHeader(),
          // 参加者リスト
          for (int index = 0; index < participants.length; index++) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.borderGray,
                    width: index == participants.length - 1 ? 0 : 1,
                  ),
                ),
              ),
              child: _buildParticipantRow(participants[index], index + 1),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.backgroundField,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 80,
            child: Text(
              'No.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              '参加者名',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
            ),
          ),
          if (showRegistrationDate)
            const SizedBox(
              width: 120,
              child: Text(
                '登録日時',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
              ),
            ),
          if (showStatus)
            const SizedBox(
              width: 200,
              child: Text(
                'ステータス',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
              ),
            ),
          const SizedBox(
            width: 100,
            child: Text(
              '操作',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantRow(ParticipantData participant, int number) {
    final isParticipating = participantStatus[participant.id] ?? true;
    final nameController = nameControllers[participant.id];

    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            '$number',
            style: const TextStyle(fontSize: 16, color: AppColors.grayDark),
          ),
        ),
        Expanded(
          child: nameController != null
              ? TextFormField(
                  controller: nameController,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textBlack,
                  ),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                )
              : Text(
                  participant.name,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textBlack,
                  ),
                ),
        ),
        if (showRegistrationDate) ...[
          const SizedBox(width: 16),
          SizedBox(
            width: 120,
            child: Text(
              participant.registeredAt != null
                  ? '${participant.registeredAt!.month}/${participant.registeredAt!.day} ${participant.registeredAt!.hour}:${participant.registeredAt!.minute.toString().padLeft(2, '0')}'
                  : '-',
              style: const TextStyle(fontSize: 14, color: AppColors.grayDark),
            ),
          ),
        ],
        if (showStatus) ...[
          const SizedBox(width: 16),
          SizedBox(
            width: 200,
            child: _buildStatusRadios(participant.id, isParticipating),
          ),
        ],
        const SizedBox(width: 16),
        SizedBox(
          width: 100,
          child: showStatus
              ? SizedBox(
                  height: 40,
                  child: CommonConfirmButton(
                    text: '削除',
                    style: ConfirmButtonStyle.alertOutlined,
                    onPressed: () => onDelete(participant),
                  ),
                )
              : IconButton(
                  onPressed: () => onDelete(participant),
                  icon: const Icon(
                    Icons.delete,
                    color: AppColors.alart,
                    size: 20,
                  ),
                  tooltip: '削除',
                ),
        ),
      ],
    );
  }

  Widget _buildStatusRadios(String participantId, bool isParticipating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 参加中ラジオボタン
        GestureDetector(
          onTap: () => onStatusChanged(participantId, isParticipating: true),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isParticipating
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: isParticipating
                    ? AppColors.successActive
                    : AppColors.textDisabled,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '参加中',
                style: TextStyle(
                  fontSize: 14,
                  color: isParticipating
                      ? AppColors.successActive
                      : AppColors.textGray,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        // ドロップラジオボタン
        GestureDetector(
          onTap: () => onStatusChanged(participantId, isParticipating: false),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                !isParticipating
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: !isParticipating
                    ? AppColors.error
                    : AppColors.textDisabled,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'ドロップ',
                style: TextStyle(
                  fontSize: 14,
                  color: !isParticipating
                      ? AppColors.error
                      : AppColors.textGray,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
