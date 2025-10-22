import 'dart:async';

import 'package:base_ui/base_ui.dart';
import 'package:clock/clock.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// 大会新規作成ダイアログ
///
/// Figmaデザイン: https://www.figma.com/design/A4NEf0vCuJNuPfBMTEa4OO/%E3%83%9E%E3%83%81%E3%82%B5%E3%83%9D?node-id=512-4453&t=whDUBuHITxOChCST-4
class CreateTournamentDialog extends ConsumerStatefulWidget {
  /// 大会新規作成ダイアログのコンストラクタ
  const CreateTournamentDialog({super.key});

  @override
  ConsumerState<CreateTournamentDialog> createState() =>
      _CreateTournamentDialogState();
}

class _CreateTournamentDialogState
    extends ConsumerState<CreateTournamentDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedCategory;
  String _selectedParticipants = '選択してください';
  String _selectedRounds = '5ラウンド';
  String _selectedDrawHandling = '選択してください';
  bool _isMaxRoundsEnabled = true;

  /// 参加人数に応じた推奨ラウンド数を計算する
  ///
  /// 参考: https://www.figma.com/design/A4NEf0vCuJNuPfBMTEa4OO/%E3%83%9E%E3%83%81%E3%82%B5%E3%83%9D?node-id=512-4453
  int _calculateRecommendedRounds(int participants) {
    switch (participants) {
      case 8:
        return 3;
      case 16:
        return 4;
      case 24:
        return 5;
      case 32:
        return 5;
      case 64:
        return 6;
      default:
        return 5; // デフォルトは5ラウンド
    }
  }

  static const _circleDecoration = BoxDecoration(
    shape: BoxShape.circle,
    color: AppColors.adminPrimary,
  );

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
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          // 背景オーバーレイ
          Container(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.2),
          ),

          // ダイアログ本体
          Center(
            child: Container(
              width: 719,
              constraints: const BoxConstraints(maxHeight: 800),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
              ),
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
                              '大会作成',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textBlack,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () => Navigator.of(context).pop(),
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
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: SizedBox(
                        width: 620,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // タイトル
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'タイトル*',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textBlack,
                                  ),
                                ),
                                const SizedBox(height: 9),
                                Container(
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
                                      hintText: '',
                                    ),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textBlack,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 9),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ListenableBuilder(
                                    listenable: _titleController,
                                    builder: (context, child) {
                                      return Text(
                                        '${_titleController.text.length}/50',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textBlack,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // 大会概要
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '大会概要*',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textBlack,
                                  ),
                                ),
                                const SizedBox(height: 9),
                                Container(
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
                                      hintText: '',
                                    ),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textBlack,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 9),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ListenableBuilder(
                                    listenable: _descriptionController,
                                    builder: (context, child) {
                                      return Text(
                                        '${_descriptionController.text.length}/200',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textBlack,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),

                            // 大会カテゴリ
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '大会カテゴリ*',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textBlack,
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
                                  child: DropdownButtonFormField<String>(
                                    initialValue: _selectedCategory,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 16,
                                      ),
                                      hintText: '選択する',
                                    ),
                                    items: TournamentCategory.all
                                        .map(
                                          (category) => DropdownMenuItem(
                                            value: category,
                                            child: Text(category),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedCategory = value;
                                      });
                                    },
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textBlack,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),

                            // 開催日
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '開催日*',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textBlack,
                                  ),
                                ),
                                const SizedBox(height: 9),
                                GestureDetector(
                                  onTap: () => _selectDate(context),
                                  child: Container(
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
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        _dateController.text.isEmpty
                                            ? 'YYYY/MM/DD'
                                            : _dateController.text,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: _dateController.text.isEmpty
                                              ? AppColors.grayDark
                                              : AppColors.textBlack,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),

                            // 参加者上限
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '参加者上限*',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textBlack,
                                  ),
                                ),
                                const SizedBox(height: 9),
                                Container(
                                  width: 342,
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
                                      value: _selectedParticipants == '選択してください'
                                          ? null
                                          : _selectedParticipants,
                                      hint: const Text(
                                        '選択してください',
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
                                      items: const ['8人', '16人', '32人', '64人']
                                          .map((item) {
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
                                          })
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedParticipants =
                                              value ?? '選択してください';

                                          // 参加人数に応じて推奨ラウンド数を自動設定
                                          if (value != null &&
                                              value != '選択してください') {
                                            final participants = int.parse(
                                              value.replaceAll('人', ''),
                                            );
                                            final recommendedRounds =
                                                _calculateRecommendedRounds(
                                              participants,
                                            );
                                            _selectedRounds =
                                                '$recommendedRoundsラウンド';
                                            // 最大ラウンド数を決める オプションを自動選択
                                            _isMaxRoundsEnabled = true;
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
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
                                                      decoration:
                                                          const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: AppColors
                                                                .adminPrimary,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                        : AppColors
                                                              .borderDisabled,
                                                    width: 2,
                                                  ),
                                                ),
                                                child: _isMaxRoundsEnabled
                                                    ? Center(
                                                        child: Container(
                                                          width: 12,
                                                          height: 12,
                                                          decoration:
                                                              _circleDecoration,
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
                                            borderRadius: BorderRadius.circular(
                                              40,
                                            ),
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
                                                    return DropdownMenuItem<
                                                      String
                                                    >(
                                                      value: item,
                                                      child: Text(
                                                        item,
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: AppColors
                                                              .textBlack,
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '引き分け処理*',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textBlack,
                                  ),
                                ),
                                const SizedBox(height: 9),
                                Container(
                                  width: 342,
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
                                      value: _selectedDrawHandling == '選択してください'
                                          ? null
                                          : _selectedDrawHandling,
                                      hint: const Text(
                                        '選択してください',
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
                                      items: const ['両者敗北', '両者勝利', '延長戦'].map((
                                        item,
                                      ) {
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
                                          _selectedDrawHandling =
                                              value ?? '選択してください';
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),

                            // 備考
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '備考',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textBlack,
                                  ),
                                ),
                                const SizedBox(height: 9),
                                Container(
                                  height: 120,
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
                                      hintText: '',
                                    ),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textBlack,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 9),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ListenableBuilder(
                                    listenable: _notesController,
                                    builder: (context, child) {
                                      return Text(
                                        '${_notesController.text.length}/200',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textBlack,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // フッター（ボタン）
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 32,
                    ),
                    child: Row(
                      children: [
                        const Spacer(),
                        // キャンセルボタン
                        Container(
                          width: 192,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(
                              color: AppColors.textBlack,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.adminPrimary.withValues(
                                  alpha: 0.1,
                                ),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: TextButton(
                            onPressed: () => Navigator.of(context).pop(),
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
                        const SizedBox(width: 8),
                        // 大会を作成ボタン
                        Container(
                          width: 192,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.adminPrimary,
                            borderRadius: BorderRadius.circular(40),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.adminPrimary.withValues(
                                  alpha: 0.1,
                                ),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: TextButton(
                            onPressed: _createTournament,
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            child: const Text(
                              '大会を作成',
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
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: clock.now(),
      firstDate: clock.now(),
      lastDate: clock.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        _dateController.text =
            '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
      });
    }
  }

  /// 参加登録用 URL を生成する。
  ///
  /// 注意: 現時点では仮の URL を使用しています。
  /// 将来的には環境変数または設定から base URL を取得する必要があります。
  String _generateRegistrationUrl(String tournamentId) {
    // 現時点では仮の URL を使用
    return 'https://example.com/tournaments/$tournamentId/register';
  }

  /// 大会作成成功ダイアログを表示する。
  Future<void> _showSuccessDialog(
    BuildContext context,
    Tournament tournament,
    String registrationUrl,
  ) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 600,
          constraints: const BoxConstraints(maxHeight: 700),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ヘッダー
              Container(
                padding: const EdgeInsets.fromLTRB(40, 48, 24, 32),
                child: Row(
                  children: [
                    const Text(
                      '大会を作成しました',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlack,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      iconSize: 24,
                      color: AppColors.textBlack,
                    ),
                  ],
                ),
              ),

              // コンテンツ
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      Text(
                        '大会名: ${tournament.title}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textBlack,
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        '参加登録用 QR コード',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlack,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.grayLight,
                            width: 2,
                          ),
                        ),
                        child: QrImageView(
                          data: registrationUrl,
                          size: 300,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        '参加登録用 URL',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textBlack,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.grayLight,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: SelectableText(
                          registrationUrl,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textBlack,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.adminPrimary,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: TextButton.icon(
                          onPressed: () {
                            unawaited(
                              Clipboard.setData(
                                ClipboardData(text: registrationUrl),
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('URL をコピーしました'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          icon: const Icon(
                            Icons.copy,
                            color: AppColors.white,
                            size: 20,
                          ),
                          label: const Text(
                            'URL をコピー',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),

              // フッター（閉じるボタン）
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 32,
                ),
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.adminPrimary,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: const Text(
                      '閉じる',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createTournament() async {
    // 入力検証
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('タイトルを入力してください')));
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('大会概要を入力してください')));
      return;
    }

    if (_selectedCategory == null || _selectedCategory!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('大会カテゴリを選択してください')));
      return;
    }

    if (_dateController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('開催日を選択してください')));
      return;
    }

    if (_selectedParticipants == '選択してください') {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('参加者上限を選択してください')));
      return;
    }

    if (_selectedDrawHandling == '選択してください') {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('引き分け処理を選択してください')));
      return;
    }

    try {
      // ISO 8601 形式の日時文字列を作成
      // YYYY/MM/DD → YYYY-MM-DD に変換
      final parts = _dateController.text.split('/');
      if (parts.length != 3) {
        throw const FormatException('日付の形式が正しくありません');
      }
      final year = parts[0].padLeft(4, '0');
      final month = parts[1].padLeft(2, '0');
      final day = parts[2].padLeft(2, '0');
      final startDate = '$year-$month-${day}T09:00:00Z';
      final endDate = '$year-$month-${day}T18:00:00Z';

      // 参加者上限を数値に変換
      final expectedPlayers = int.parse(
        _selectedParticipants.replaceAll('人', ''),
      );

      // ラウンド数を数値に変換（手動指定時のみ）
      final maxRounds = _isMaxRoundsEnabled
          ? int.parse(
              _selectedRounds.replaceAll('ラウンド', ''),
            )
          : null;

      // 引き分け処理を得点に変換
      // 両者勝利 = 1点、両者敗北 = 0点、延長戦 = 0点（延長戦は通常の試合として扱う）
      final drawPoints = _selectedDrawHandling == '両者勝利' ? 1 : 0;

      // 会場は仮で「オンライン開催」を設定（将来的に入力フィールド追加予定）
      const venue = 'オンライン開催';

      final createUseCase = ref.read(createTournamentUseCaseProvider);

      final tournament = await createUseCase.call(
        CreateTournamentRequest(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          category: _selectedCategory!,
          venue: venue,
          startDate: startDate,
          endDate: endDate,
          maxRounds: maxRounds,
          drawPoints: drawPoints,
          expectedPlayers: expectedPlayers,
        ),
      );

      if (mounted) {
        // 参加登録用 URL の生成
        final registrationUrl = _generateRegistrationUrl(tournament.id);

        Navigator.of(context).pop();
        await _showSuccessDialog(context, tournament, registrationUrl);
      }
    } on FormatException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('入力エラー: ${e.message}')));
      }
    } on FailureStatusException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('エラー: ${e.message}')));
      }
    } on GeneralFailureException catch (e) {
      if (mounted) {
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('予期しないエラーが発生しました: $e')));
      }
    }
  }
}
