import 'package:base_ui/base_ui.dart';
import 'package:flutter/material.dart';

import '../home/tournament_detail_page.dart';

/// 大会編集ダイアログ
///
/// Figmaデザイン: https://www.figma.com/design/A4NEf0vCuJNuPfBMTEa4OO/%E3%83%9E%E3%83%81%E3%82%B5%E3%83%9D?node-id=550-4806&t=3LcouErPKHmLq3zh-4
class EditTournamentDialog extends StatefulWidget {
  /// 大会編集ダイアログのコンストラクタ
  const EditTournamentDialog({required this.tournament, super.key});

  /// 編集対象のトーナメントデータ
  final TournamentDetailData tournament;

  @override
  State<EditTournamentDialog> createState() => _EditTournamentDialogState();
}

class _EditTournamentDialogState extends State<EditTournamentDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _dateController;
  late final TextEditingController _timeController;
  late final TextEditingController _notesController;

  late String _selectedParticipants;
  late String _selectedRounds;
  late String _selectedDrawHandling;

  @override
  void initState() {
    super.initState();

    // 既存データで初期化
    _titleController = TextEditingController(text: widget.tournament.title);
    _descriptionController = TextEditingController(
      text: widget.tournament.description,
    );
    _dateController = TextEditingController(text: widget.tournament.date);
    _timeController = TextEditingController(text: widget.tournament.time);
    _notesController = TextEditingController(text: widget.tournament.notes);

    _selectedParticipants = '${widget.tournament.maxParticipants}人';
    _selectedRounds = widget.tournament.maxRounds;
    _selectedDrawHandling = widget.tournament.drawHandling;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        width: 719,
        constraints: const BoxConstraints(maxHeight: 800),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ヘッダー
            Container(
              padding: const EdgeInsets.fromLTRB(40, 48, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        '大会編集',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlack,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          if (mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                        icon: const Icon(Icons.close),
                        iconSize: 24,
                        color: AppColors.textBlack,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '*マークのある項目は必須です',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textBlack,
                    ),
                  ),
                ],
              ),
            ),

            // コンテンツ
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // タイトル
                    _buildFormField(
                      label: 'タイトル',
                      isRequired: true,
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.grayLight,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: TextField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            hintText: 'タイトルを入力してください',
                          ),
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textBlack,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 大会の説明
                    _buildFormField(
                      label: '大会の説明',
                      isRequired: true,
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.grayLight,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextField(
                          controller: _descriptionController,
                          maxLines: null,
                          expands: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                            hintText: '大会の説明を入力してください',
                          ),
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textBlack,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 開催日時行
                    Row(
                      children: [
                        // 開催日
                        Expanded(
                          child: _buildFormField(
                            label: '開催日',
                            isRequired: true,
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                color: AppColors.grayLight,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: TextField(
                                controller: _dateController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 16,
                                  ),
                                  hintText: 'YYYY/MM/DD',
                                ),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textBlack,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        // 開催時間
                        Expanded(
                          child: _buildFormField(
                            label: '開催時間',
                            isRequired: true,
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                color: AppColors.grayLight,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: TextField(
                                controller: _timeController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 16,
                                  ),
                                  hintText: 'HH:MM-HH:MM',
                                ),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textBlack,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // 参加者上限行
                    Row(
                      children: [
                        // 参加者上限
                        Expanded(
                          child: _buildFormField(
                            label: '参加者上限',
                            isRequired: true,
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                color: AppColors.grayLight,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: DropdownButtonFormField<String>(
                                initialValue: _selectedParticipants,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 16,
                                  ),
                                ),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textBlack,
                                ),
                                items: ['8人', '16人', '32人', '64人'].map((
                                  String value,
                                ) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      _selectedParticipants = newValue;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        // 最大ラウンド
                        Expanded(
                          child: _buildFormField(
                            label: '最大ラウンド',
                            isRequired: true,
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                color: AppColors.grayLight,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: DropdownButtonFormField<String>(
                                initialValue: _selectedRounds,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 16,
                                  ),
                                ),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textBlack,
                                ),
                                items: ['3ラウンド', '5ラウンド', '7ラウンド'].map((
                                  String value,
                                ) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      _selectedRounds = newValue;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // 引き分け処理
                    _buildFormField(
                      label: '引き分け処理',
                      isRequired: true,
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.grayLight,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedDrawHandling,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textBlack,
                          ),
                          items: ['あり', 'なし'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedDrawHandling = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 備考
                    _buildFormField(
                      label: '備考',
                      isRequired: false,
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.grayLight,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextField(
                          controller: _notesController,
                          maxLines: null,
                          expands: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                            hintText: '備考があれば入力してください',
                          ),
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textBlack,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // フッター（ボタン）
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
              child: Row(
                children: [
                  const Spacer(),
                  // キャンセルボタン
                  Container(
                    width: 192,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: AppColors.textBlack, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.adminPrimary.withValues(alpha: 0.1),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {
                        if (mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: const Text(
                        'キャンセル',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlack,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // 保存ボタン
                  Container(
                    width: 192,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.adminPrimary,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.adminPrimary.withValues(alpha: 0.1),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: _saveTournament,
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: const Text(
                        '変更を保存',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// フォームフィールドのラベル付きレイアウトを構築
  Widget _buildFormField({
    required String label,
    required bool isRequired,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlack,
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: 4),
              const Text(
                '*',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.error,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  /// トーナメント保存処理
  Future<void> _saveTournament() async {
    // mounted チェックを最初に行う
    if (!mounted) {
      return;
    }

    // 実際の保存処理を実装する必要があります

    // バリデーション
    if (_titleController.text.isEmpty) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('タイトルは必須です'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_descriptionController.text.isEmpty) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('大会の説明は必須です'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_dateController.text.isEmpty) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('開催日は必須です'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_timeController.text.isEmpty) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('開催時間は必須です'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // 追加のバリデーション
    if (_selectedParticipants.isEmpty) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('参加者上限は必須です'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_selectedRounds.isEmpty) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('最大ラウンドは必須です'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_selectedDrawHandling.isEmpty) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('引き分け処理は必須です'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // 成功メッセージを表示してダイアログを閉じる
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('大会情報を更新しました'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.of(context).pop();
    }
  }
}
