import 'package:base_ui/base_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../home/tournament_detail_page.dart' as detail_page;

/// 大会編集ダイアログ
///
/// Figmaデザイン: https://www.figma.com/design/A4NEf0vCuJNuPfBMTEa4OO/%E3%83%9E%E3%83%81%E3%82%B5%E3%83%9D?node-id=550-4806&t=3LcouErPKHmLq3zh-4
class EditTournamentDialog extends ConsumerStatefulWidget {
  /// 大会編集ダイアログのコンストラクタ
  const EditTournamentDialog({required this.tournament, super.key});

  /// 編集対象のトーナメントデータ
  final detail_page.TournamentDetailData tournament;

  @override
  ConsumerState<EditTournamentDialog> createState() =>
      _EditTournamentDialogState();
}

class _EditTournamentDialogState extends ConsumerState<EditTournamentDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _dateController;
  late final TextEditingController _notesController;

  late String _selectedCategory;
  late String _selectedParticipants;
  late String _selectedRounds;
  late String _selectedDrawHandling;
  late String _selectedStartTime;
  late String _selectedEndTime;
  late bool _isMaxRoundsEnabled;

  @override
  void initState() {
    super.initState();

    // 既存データで初期化
    final tournament = widget.tournament;
    _titleController = TextEditingController(text: tournament.title);
    _descriptionController = TextEditingController(
      text: tournament.description,
    );
    _dateController = TextEditingController(text: tournament.date);
    _notesController = TextEditingController(text: tournament.remarks);

    // カテゴリが空の場合、または有効なカテゴリでない場合はデフォルト値を使用する。
    _selectedCategory =
        tournament.category.isEmpty ||
            !TournamentCategory.all.contains(tournament.category)
        ? TournamentCategory.pokemon
        : tournament.category;
    _selectedParticipants = '${tournament.maxParticipants}人';

    // 最大ラウンドの初期化
    // '勝者が1人になるまで' または空の場合は、ELIMINATION モード
    if (tournament.maxRounds.isEmpty || tournament.maxRounds == '勝者が1人になるまで') {
      _isMaxRoundsEnabled = false;
      _selectedRounds = '3ラウンド'; // デフォルト値（ドロップダウン用）
    } else {
      _isMaxRoundsEnabled = true;
      _selectedRounds = tournament.maxRounds;
    }

    // 既存データの引き分け処理を新しい選択肢にマッピング
    // 「あり」「両者勝利」「延長戦」→「引き分け」、「なし」→「両者敗北」
    _selectedDrawHandling = switch (tournament.drawHandling) {
      'あり' || '両者勝利' || '延長戦' => '引き分け',
      'なし' => '両者敗北',
      '引き分け' => '引き分け',
      '両者敗北' => '両者敗北',
      _ => '引き分け', // デフォルトは引き分け
    };

    // 時刻を開始時刻と終了時刻に分割（HH:MM-HH:MM形式を想定）
    if (tournament.time.contains('-')) {
      final timeParts = tournament.time.split('-');
      _selectedStartTime = timeParts[0].trim();
      _selectedEndTime = timeParts[1].trim();
    } else {
      _selectedStartTime = '09:00';
      _selectedEndTime = '18:00';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
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

                    const SizedBox(height: 16),

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

                    const SizedBox(height: 32),

                    // 大会カテゴリ
                    _buildFormField(
                      label: '大会カテゴリ',
                      isRequired: true,
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.grayLight,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedCategory,
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
                          items: TournamentCategory.all.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedCategory = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // 開催日
                    _buildFormField(
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

                    const SizedBox(height: 32),

                    // 開催時間
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '開催時間*',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textBlack,
                          ),
                        ),
                        const SizedBox(height: 9),
                        Row(
                          children: [
                            // 開始時刻
                            Container(
                              width: 166,
                              height: 56,
                              decoration: BoxDecoration(
                                color: AppColors.grayLight,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 13,
                                vertical: 16,
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedStartTime,
                                  hint: const Text(
                                    '開始時刻',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.grayDark,
                                    ),
                                  ),
                                  icon: Transform.rotate(
                                    angle: 1.5708, // 90度回転
                                    child: const Icon(
                                      Icons.keyboard_arrow_right,
                                      size: 24,
                                      color: AppColors.textBlack,
                                    ),
                                  ),
                                  isExpanded: true,
                                  items: _generateTimeOptions().map((item) {
                                    return DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textBlack,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedStartTime = value ?? '09:00';
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              '〜',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textBlack,
                              ),
                            ),
                            const SizedBox(width: 10),
                            // 終了時刻
                            Container(
                              width: 166,
                              height: 56,
                              decoration: BoxDecoration(
                                color: AppColors.grayLight,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 13,
                                vertical: 16,
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedEndTime,
                                  hint: const Text(
                                    '終了時刻',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.grayDark,
                                    ),
                                  ),
                                  icon: Transform.rotate(
                                    angle: 1.5708, // 90度回転
                                    child: const Icon(
                                      Icons.keyboard_arrow_right,
                                      size: 24,
                                      color: AppColors.textBlack,
                                    ),
                                  ),
                                  isExpanded: true,
                                  items: _generateTimeOptions().map((item) {
                                    return DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textBlack,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedEndTime = value ?? '18:00';
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // 参加者上限
                    _buildFormField(
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

                    const SizedBox(height: 32),

                    // 最大ラウンド
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '最大ラウンド*',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textBlack,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ラジオボタン
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _isMaxRoundsEnabled = false;
                                });
                              },
                              child: Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: !_isMaxRoundsEnabled
                                            ? AppColors.adminPrimary
                                            : AppColors.borderDisabled,
                                        width: 2,
                                      ),
                                    ),
                                    child: !_isMaxRoundsEnabled
                                        ? Center(
                                            child: Container(
                                              width: 12,
                                              height: 12,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColors.adminPrimary,
                                              ),
                                            ),
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    '勝者が1人に決まるまで',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textBlack,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isMaxRoundsEnabled = true;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: _isMaxRoundsEnabled
                                                ? AppColors.adminPrimary
                                                : AppColors.borderDisabled,
                                            width: 2,
                                          ),
                                        ),
                                        child: _isMaxRoundsEnabled
                                            ? Center(
                                                child: Container(
                                                  width: 12,
                                                  height: 12,
                                                  decoration:
                                                      const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: AppColors
                                                            .adminPrimary,
                                                      ),
                                                ),
                                              )
                                            : null,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        '最大ラウンド数を決める',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textBlack,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 9),
                                Container(
                                  width: 342,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: AppColors.grayLight,
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 13,
                                    vertical: 16,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedRounds,
                                      icon: Transform.rotate(
                                        angle: 1.5708, // 90度回転
                                        child: const Icon(
                                          Icons.keyboard_arrow_right,
                                          size: 24,
                                          color: AppColors.textBlack,
                                        ),
                                      ),
                                      isExpanded: true,
                                      items:
                                          const [
                                            '3ラウンド',
                                            '4ラウンド',
                                            '5ラウンド',
                                            '6ラウンド',
                                            '7ラウンド',
                                          ].map((item) {
                                            return DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(
                                                item,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.textBlack,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedRounds = value!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

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
                          items: ['引き分け', '両者敗北'].map((String value) {
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

                    const SizedBox(height: 32),

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

                    const SizedBox(height: 32),
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
                      color: AppColors.white,
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
                          color: AppColors.white,
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

  /// 時刻の選択肢を生成する（09:00〜22:00まで30分刻み）
  List<String> _generateTimeOptions() {
    final times = <String>[];
    for (var hour = 9; hour <= 22; hour++) {
      times.add('${hour.toString().padLeft(2, '0')}:00');
      if (hour < 22) {
        times.add('${hour.toString().padLeft(2, '0')}:30');
      }
    }
    return times;
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
        Text(
          isRequired ? '$label*' : label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textBlack,
          ),
        ),
        const SizedBox(height: 9),
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

    if (_selectedCategory.isEmpty) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('大会カテゴリは必須です'),
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

    if (_selectedStartTime.isEmpty || _selectedEndTime.isEmpty) {
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

    if (_isMaxRoundsEnabled && _selectedRounds.isEmpty) {
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

    try {
      // 日付と時刻をISO 8601形式に変換
      final dateParts = _dateController.text.split('/');
      if (dateParts.length != 3) {
        throw const FormatException('日付の形式が正しくありません');
      }
      final year = dateParts[0].padLeft(4, '0');
      final month = dateParts[1].padLeft(2, '0');
      final day = dateParts[2].padLeft(2, '0');

      // 開始日と終了日（ISO 8601形式）
      final startDate = '$year-$month-${day}T00:00:00Z';
      final endDate = '$year-$month-${day}T23:59:59Z';

      // 引き分け処理を得点に変換（引き分け = 1点、両者敗北 = 0点）
      final drawPoints = _selectedDrawHandling == '引き分け' ? 1 : 0;

      // 最大ラウンド数（自動の場合はnull）
      // "4ラウンド" -> 4 のように数値部分だけを抽出
      final maxRounds = _isMaxRoundsEnabled && _selectedRounds.isNotEmpty
          ? int.tryParse(_selectedRounds.replaceAll(RegExp('[^0-9]'), ''))
          : null;

      // 参加者上限
      // "32人" -> 32 のように数値部分だけを抽出
      final expectedPlayers = int.tryParse(
        _selectedParticipants.replaceAll(RegExp('[^0-9]'), ''),
      );

      // トーナメントIDを取得
      final tournamentId = widget.tournament.id;

      // 大会運営方式を決定
      final tournamentMode = _isMaxRoundsEnabled
          ? 'FIXED_ROUNDS'
          : 'ELIMINATION';

      // UseCaseを直接呼び出す（例外処理のため）
      final updateUseCase = ref.read(updateTournamentUseCaseProvider);
      await updateUseCase.invoke(
        id: tournamentId,
        name: _titleController.text.trim(),
        overview: _descriptionController.text.trim(),
        category: _selectedCategory,
        tournamentMode: tournamentMode,
        startDate: startDate,
        endDate: endDate,
        startTime: _selectedStartTime,
        endTime: _selectedEndTime,
        drawPoints: drawPoints,
        maxRounds: maxRounds,
        expectedPlayers: expectedPlayers,
        remarks: _notesController.text.trim().isNotEmpty
            ? _notesController.text.trim()
            : null,
      );

      if (!mounted) {
        return;
      }

      // トーナメント一覧を再読み込みする。
      ref.invalidate(tournamentListNotifierProvider);

      // トーナメント詳細を再取得（最新データをFirestoreから取得）
      await ref
          .read(tournamentDetailNotifierProvider.notifier)
          .refreshTournament(widget.tournament.id);

      if (!mounted) {
        return;
      }

      // 成功メッセージを表示してダイアログを閉じる。
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('大会情報を更新しました'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.of(context).pop();
    } on FormatException catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('入力エラー: ${e.message}'),
          backgroundColor: AppColors.error,
        ),
      );
    } on FailureStatusException catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('エラー: ${e.message}'),
          backgroundColor: AppColors.error,
        ),
      );
    } on GeneralFailureException catch (e) {
      if (!mounted) {
        return;
      }
      String message;
      switch (e.reason) {
        case GeneralFailureReason.other:
          message = '認証に失敗しました。再度ログインしてください。';
        case GeneralFailureReason.noConnectionError:
          message = 'ネットワークに接続できません。';
        case GeneralFailureReason.serverUrlNotFoundError:
          message = 'サーバーURLが見つかりません。';
        case GeneralFailureReason.badResponse:
          message = '不正なレスポンスです。';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: AppColors.error),
      );
    } on Exception catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('予期しないエラーが発生しました: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
