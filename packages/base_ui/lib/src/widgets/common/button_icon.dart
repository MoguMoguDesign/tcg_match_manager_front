import 'package:flutter/material.dart';

/// ボタンアイコンウィジェット。
///
/// Figma の ButtonIcon コンポーネント（node-id: 244-1230, 244-1232, 244-2294）に準拠し、
/// 3つのバリアント（Default/Edit/QR）を提供する。
class ButtonIcon extends StatelessWidget {
  /// [ButtonIcon] のコンストラクタ。
  ///
  /// [type] でアイコンの種類を指定する。
  const ButtonIcon({
    super.key,
    this.type = ButtonIconType.defaultIcon,
    this.size = 24,
    this.color,
  });

  /// アイコンの種類。
  final ButtonIconType type;

  /// アイコンのサイズ。
  final double size;

  /// アイコンの色。指定しない場合はデフォルト色を使用。
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: _buildIconContent(),
    );
  }

  /// アイコンの種類に応じてコンテンツを構築する。
  Widget _buildIconContent() {
    switch (type) {
      case ButtonIconType.defaultIcon:
        return _buildDefaultIcon();
      case ButtonIconType.edit:
        return _buildEditIcon();
      case ButtonIconType.qr:
        return _buildQRIcon();
    }
  }

  /// デフォルトアイコン（プラス記号）を構築する。
  Widget _buildDefaultIcon() {
    return Stack(
      children: [
        // 背景円
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color ?? Colors.white.withValues(alpha: 0.2),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
        ),
        // プラスアイコン
        Positioned.fill(
          child: Icon(
            Icons.add,
            size: size * 0.6,
            color: color ?? Colors.white,
          ),
        ),
      ],
    );
  }

  /// 編集アイコンを構築する。
  Widget _buildEditIcon() {
    return Stack(
      children: [
        // 背景円
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color ?? Colors.white.withValues(alpha: 0.2),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
        ),
        // 編集アイコン
        Positioned.fill(
          child: Icon(
            Icons.edit,
            size: size * 0.5,
            color: color ?? Colors.white,
          ),
        ),
      ],
    );
  }

  /// QRアイコンを構築する。
  Widget _buildQRIcon() {
    return Stack(
      children: [
        // 背景円
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color ?? Colors.white.withValues(alpha: 0.2),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
        ),
        // QRアイコン
        Positioned.fill(
          child: Icon(
            Icons.qr_code,
            size: size * 0.6,
            color: color ?? Colors.white,
          ),
        ),
      ],
    );
  }
}

/// ボタンアイコンの種類を表す列挙型。
enum ButtonIconType {
  /// デフォルトアイコン（プラス記号）。
  defaultIcon,

  /// 編集アイコン。
  edit,

  /// QRコードアイコン。
  qr,
}
