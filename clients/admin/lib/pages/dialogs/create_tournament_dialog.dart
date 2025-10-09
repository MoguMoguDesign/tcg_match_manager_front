import 'package:base_ui/base_ui.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';

/// 大会新規作成ダイアログ
///
/// Figmaデザイン: https://www.figma.com/design/A4NEf0vCuJNuPfBMTEa4OO/%E3%83%9E%E3%83%81%E3%82%B5%E3%83%9D?node-id=512-4453&t=whDUBuHITxOChCST-4
class CreateTournamentDialog extends StatefulWidget {
  /// 大会新規作成ダイアログのコンストラクタ
  const CreateTournamentDialog({super.key});

  @override
  State<CreateTournamentDialog> createState() => _CreateTournamentDialogState();
}

class _CreateTournamentDialogState extends State<CreateTournamentDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedParticipants = '選択してください';
  String _selectedRounds = '5ラウンド（推奨）';
  String _selectedDrawHandling = '選択してください';
  bool _isMaxRoundsEnabled = true;

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
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.black.withValues(alpha: 0.2),
          ),

          // ダイアログ本体
          Center(
            child: Container(
              width: 719,
              constraints: const BoxConstraints(maxHeight: 800),
              decoration: BoxDecoration(
                color: Colors.white,
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
                                    child: Row(
                                      children: [
                                        Text(
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
                                      ],
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
                                                              // ネスト対応。
                                                              // ignore: lines_longer_than_80_chars
                                                              const BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Color
                                                                    .fromRGBO(
                                                                  58,
                                                                  68,
                                                                  251,
                                                                  1,
                                                                ),
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
                                                    '5ラウンド（推奨）',
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
                            color: Colors.white,
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
      _dateController.text =
          '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
    }
  }

  void _createTournament() {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('トーナメントを作成しました')));
  }
}
