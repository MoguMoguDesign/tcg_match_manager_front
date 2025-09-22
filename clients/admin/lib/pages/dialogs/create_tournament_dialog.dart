import 'package:base_ui/base_ui.dart';
import 'package:flutter/material.dart';

/// 大会新規作成ダイアログ
///
/// Figmaデザイン: https://www.figma.com/design/A4NEf0vCuJNuPfBMTEa4OO/%E3%83%9E%E3%83%81%E3%82%B5%E3%83%9D?node-id=96-875&t=whDUBuHITxOChCST-4
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
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 700),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ヘッダー
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFE0E0E0),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    '新規作成',
                    style: AppTextStyles.headlineLarge.copyWith(
                      color: AppColors.textBlack,
                      fontSize: 20,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    color: AppColors.gray,
                  ),
                ],
              ),
            ),
            
            // コンテンツ
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 説明テキスト
                    Text(
                      '*マークのある項目は必須です',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.gray,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // タイトル
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'タイトル*',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.gray,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        FigmaTextField(
                          hintText: 'トーナメント名を入力',
                          controller: _titleController,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // 大会概要
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '大会概要*',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.gray,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        FigmaTextField(
                          hintText: '大会の説明を入力（200文字以内）',
                          controller: _descriptionController,
                          maxLines: 4,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // 開催日
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '開催日*',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.gray,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: AbsorbPointer(
                            child: FigmaTextField(
                              hintText: 'YYYY/MM/DD',
                              controller: _dateController,
                              suffixIcon: const Icon(Icons.calendar_today),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // 参加者上限
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '参加者上限*',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.gray,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.gray),
                          ),
                          child: DropdownButtonFormField<String>(
                            initialValue: _selectedParticipants == '選択してください'
                                ? null
                                : _selectedParticipants,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(16),
                              hintText: '参加者数を選択',
                            ),
                            items: const [
                              '8人',
                              '16人',
                              '32人',
                              '64人',
                            ].map((item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedParticipants = value ?? '選択してください';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // 最大ラウンド
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '最大ラウンド*',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.gray,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        
                        // ラジオボタン
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _isMaxRoundsEnabled = false;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.zero,
                                child: Row(
                                  children: [
                                    Radio<bool>(
                                      value: false,
                                      // Using deprecated API until migration
                                      // ignore: deprecated_member_use
                                      groupValue: _isMaxRoundsEnabled,
                                      // Using deprecated API until migration
                                      // ignore: deprecated_member_use
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() {
                                            _isMaxRoundsEnabled = value;
                                          });
                                        }
                                      },
                                    ),
                                    const Expanded(
                                      child: Text('勝者が1人に決まるまで'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _isMaxRoundsEnabled = true;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.zero,
                                child: Row(
                                  children: [
                                    Radio<bool>(
                                      value: true,
                                      // Using deprecated API until migration
                                      // ignore: deprecated_member_use
                                      groupValue: _isMaxRoundsEnabled,
                                      // Using deprecated API until migration
                                      // ignore: deprecated_member_use
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() {
                                            _isMaxRoundsEnabled = value;
                                          });
                                        }
                                      },
                                    ),
                                    const Expanded(
                                      child: Text('最大ラウンド数を決める'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        // ドロップダウン
                        if (_isMaxRoundsEnabled) ...[
                          const SizedBox(height: 8),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.gray),
                            ),
                            child: DropdownButtonFormField<String>(
                              initialValue: _selectedRounds,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(16),
                              ),
                              items: const [
                                '3ラウンド',
                                '4ラウンド',
                                '5ラウンド（推奨）',
                                '6ラウンド',
                                '7ラウンド',
                              ].map((item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedRounds = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // 引き分け処理
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '引き分け処理*',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.gray,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.gray),
                          ),
                          child: DropdownButtonFormField<String>(
                            initialValue: _selectedDrawHandling == '選択してください'
                                ? null
                                : _selectedDrawHandling,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(16),
                              hintText: '引き分け時の処理を選択',
                            ),
                            items: const [
                              '両者敗北',
                              '両者勝利',
                              '延長戦',
                            ].map((item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedDrawHandling = value ?? '選択してください';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // 備考
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '備考',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.gray,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        FigmaTextField(
                          hintText: '備考・補足情報を入力（200文字以内）',
                          controller: _notesController,
                          maxLines: 4,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // フッター（ボタン）
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color(0xFFE0E0E0),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CommonConfirmButton(
                      text: 'キャンセル',
                      style: ConfirmButtonStyle.adminOutlined,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CommonConfirmButton(
                      text: '大会を作成',
                      style: ConfirmButtonStyle.adminFilled,
                      onPressed: _createTournament,
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


  Future<void> _selectDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      _dateController.text = '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
    }
  }

  void _createTournament() {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('トーナメントを作成しました'),
      ),
    );
  }
}
