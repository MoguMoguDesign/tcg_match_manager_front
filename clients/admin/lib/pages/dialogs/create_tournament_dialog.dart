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
          color: Colors.white,
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
                  const Text(
                    '新規作成',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF000336),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    color: const Color(0xFF7A7A83),
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
                    const Text(
                      '*マークのある項目は必須です',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF7A7A83),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // タイトル
                    _buildTextField(
                      label: 'タイトル*',
                      controller: _titleController,
                      maxLength: 50,
                    ),
                    const SizedBox(height: 20),
                    
                    // 大会概要
                    _buildTextField(
                      label: '大会概要*',
                      controller: _descriptionController,
                      maxLines: 4,
                      maxLength: 200,
                    ),
                    const SizedBox(height: 20),
                    
                    // 開催日
                    _buildTextField(
                      label: '開催日*',
                      controller: _dateController,
                      placeholder: 'YYYY/MM/DD',
                      readOnly: true,
                      onTap: () => _selectDate(context),
                    ),
                    const SizedBox(height: 20),
                    
                    // 参加者上限
                    _buildDropdownField(
                      label: '参加者上限*',
                      value: _selectedParticipants,
                      items: const [
                        '選択してください',
                        '8人',
                        '16人',
                        '32人',
                        '64人',
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedParticipants = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    
                    // 最大ラウンド
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '最大ラウンド*',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7A7A83),
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
                          _buildDropdownField(
                            label: '',
                            value: _selectedRounds,
                            items: const [
                              '3ラウンド',
                              '4ラウンド',
                              '5ラウンド（推奨）',
                              '6ラウンド',
                              '7ラウンド',
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedRounds = value!;
                              });
                            },
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // 引き分け処理
                    _buildDropdownField(
                      label: '引き分け処理*',
                      value: _selectedDrawHandling,
                      items: const [
                        '選択してください',
                        '両者敗北',
                        '両者勝利',
                        '延長戦',
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedDrawHandling = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    
                    // 備考
                    _buildTextField(
                      label: '備考',
                      controller: _notesController,
                      maxLines: 4,
                      maxLength: 200,
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? placeholder,
    int maxLines = 1,
    int? maxLength,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF7A7A83),
            ),
          ),
          const SizedBox(height: 8),
        ],
        DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            maxLength: maxLength,
            readOnly: readOnly,
            onTap: onTap,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              hintText: placeholder,
              hintStyle: const TextStyle(
                color: Color(0xFF7A7A83),
              ),
              counterText: maxLength != null ? '${controller.text.length}/$maxLength' : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF7A7A83),
            ),
          ),
          const SizedBox(height: 8),
        ],
        DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<String>(
            initialValue: value,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
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
