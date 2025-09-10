import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';

/// 新しいデザインのテキスト入力フィールドウィジェット。
///
/// Figma の TextField（node-id: 86-7923）に準拠し、
/// アプリ全体で統一されたテキスト入力体験を提供する。
class FigmaTextField extends StatelessWidget {
  /// [FigmaTextField] のコンストラクタ。
  ///
  /// [hintText] は必須パラメータ。
  /// その他のパラメータはオプショナル。
  const FigmaTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.errorText,
  });

  /// プレースホルダーテキスト。
  final String hintText;

  /// テキスト入力を制御するコントローラー。
  final TextEditingController? controller;

  /// テキスト変更時のコールバック。
  final ValueChanged<String>? onChanged;

  /// エンターキー押下時のコールバック。
  final ValueChanged<String>? onSubmitted;

  /// キーボードタイプ。
  final TextInputType keyboardType;

  /// パスワード入力時などに文字を隠すかどうか。
  final bool obscureText;

  /// フィールドが有効かどうか。
  final bool enabled;

  /// 最大行数。
  final int maxLines;

  /// プレフィックスアイコン。
  final Widget? prefixIcon;

  /// サフィックスアイコン。
  final Widget? suffixIcon;

  /// エラーテキスト。
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: maxLines == 1 ? 56 : null,
          constraints: maxLines > 1 
              ? const BoxConstraints(minHeight: 56) 
              : null,
          decoration: BoxDecoration(
            color: enabled 
                ? AppColors.textBlack 
                : AppColors.gray.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: hasError 
                  ? Colors.red 
                  : AppColors.whiteAlpha,
              width: hasError ? 2 : 1,
            ),
          ),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            keyboardType: keyboardType,
            obscureText: obscureText,
            enabled: enabled,
            maxLines: maxLines,
            style: AppTextStyles.bodyMedium.copyWith(
              color: enabled ? AppColors.white : AppColors.gray,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.gray,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: maxLines == 1 ? 16 : 14,
              ),
              prefixIcon: prefixIcon != null 
                  ? Padding(
                      padding: const EdgeInsets.only(left: 16, right: 12),
                      child: prefixIcon,
                    )
                  : null,
              prefixIconConstraints: prefixIcon != null
                  ? const BoxConstraints()
                  : null,
              suffixIcon: suffixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 12, right: 16),
                      child: suffixIcon,
                    )
                  : null,
              suffixIconConstraints: suffixIcon != null
                  ? const BoxConstraints()
                  : null,
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              errorText!,
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// パスワード入力用のテキストフィールド。
///
/// 表示/非表示の切り替えボタンが付いたパスワード入力フィールド。
class PasswordTextField extends StatefulWidget {
  /// [PasswordTextField] のコンストラクタ。
  const PasswordTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.errorText,
  });

  /// プレースホルダーテキスト。
  final String hintText;

  /// テキスト入力を制御するコントローラー。
  final TextEditingController? controller;

  /// テキスト変更時のコールバック。
  final ValueChanged<String>? onChanged;

  /// エンターキー押下時のコールバック。
  final ValueChanged<String>? onSubmitted;

  /// フィールドが有効かどうか。
  final bool enabled;

  /// エラーテキスト。
  final String? errorText;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FigmaTextField(
      hintText: widget.hintText,
      controller: widget.controller,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      keyboardType: TextInputType.visiblePassword,
      obscureText: _obscureText,
      enabled: widget.enabled,
      errorText: widget.errorText,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: AppColors.gray,
          size: 20,
        ),
        onPressed: _toggleObscureText,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      ),
    );
  }
}

/// 検索用のテキストフィールド。
///
/// 検索アイコンが付いた検索専用の入力フィールド。
class SearchTextField extends StatelessWidget {
  /// [SearchTextField] のコンストラクタ。
  const SearchTextField({
    super.key,
    this.hintText = '検索...',
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
  });

  /// プレースホルダーテキスト。
  final String hintText;

  /// テキスト入力を制御するコントローラー。
  final TextEditingController? controller;

  /// テキスト変更時のコールバック。
  final ValueChanged<String>? onChanged;

  /// エンターキー押下時のコールバック。
  final ValueChanged<String>? onSubmitted;

  /// フィールドが有効かどうか。
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return FigmaTextField(
      hintText: hintText,
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      enabled: enabled,
      prefixIcon: const Icon(
        Icons.search,
        color: AppColors.gray,
        size: 20,
      ),
    );
  }
}

/// ドロップダウン選択フィールド。
///
/// Figma の TextField（node-id: 86-7920）に準拠した選択フィールド。
/// リストから値を選択する際に使用する。
class DropdownSelectField<T> extends StatelessWidget {
  /// [DropdownSelectField] のコンストラクタ。
  const DropdownSelectField({
    super.key,
    required this.hintText,
    required this.items,
    this.value,
    this.onChanged,
    this.enabled = true,
    this.itemBuilder,
  });

  /// プレースホルダーテキスト。
  final String hintText;

  /// 選択可能なアイテム一覧。
  final List<T> items;

  /// 現在選択されている値。
  final T? value;

  /// 選択変更時のコールバック。
  final ValueChanged<T?>? onChanged;

  /// フィールドが有効かどうか。
  final bool enabled;

  /// アイテムの表示形式をカスタマイズするビルダー。
  final Widget Function(T item)? itemBuilder;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: enabled 
            ? AppColors.textBlack 
            : AppColors.gray.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: AppColors.whiteAlpha,
          width: 1,
        ),
      ),
      child: DropdownButtonFormField<T>(
        initialValue: value,
        onChanged: enabled ? onChanged : null,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.gray,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        style: AppTextStyles.bodyMedium.copyWith(
          color: enabled ? AppColors.white : AppColors.gray,
        ),
        dropdownColor: AppColors.textBlack,
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: enabled ? AppColors.white : AppColors.gray,
        ),
        items: items.map((T item) {
          return DropdownMenuItem<T>(
            value: item,
            child: itemBuilder?.call(item) ?? Text(
              item.toString(),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.white,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
