import 'package:freezed_annotation/freezed_annotation.dart';

/// [FlexibleBoolConverter] インスタンス。
///
/// デフォルト値は false となる。
const flexibleBoolConverter = FlexibleBoolConverter._();

/// デフォルト値が true の [FlexibleBoolConverter] インスタンス。
const flexibleBoolConverterTrueDefault = FlexibleBoolConverter._(
  defaultValue: true,
);

/// [bool] 型を柔軟に変換するための [JsonConverter].
///
/// 実際の利用場面では、インスタンス化された
/// [flexibleBoolConverter] 若しくは [flexibleBoolConverterTrueDefault] を使用する。
class FlexibleBoolConverter implements JsonConverter<bool, Object?> {
  const FlexibleBoolConverter._({this.defaultValue = false});

  /// デフォルト値。
  ///
  /// [fromJson] の際に null が渡された場合や、
  /// [String] 若しくは [int] 以外の型が渡された場合に使用される。
  final bool defaultValue;

  /// [json] を [bool] に変換する。
  ///
  /// [json] が null の場合や不適切な型の場合、[defaultValue] を返す。
  /// [json] が [String] 型や [int] 型の場合、0 であれば false を、1 であれば true を返す。
  /// 0 若しくは 1 以外であれば true を返す。
  @override
  bool fromJson(Object? json) {
    if (json == null) {
      return defaultValue;
    }

    if (json is String) {
      return switch (json) {
        '0' => false,
        '1' => true,
        _ => true,
      };
    }

    if (json is int) {
      return switch (json) {
        0 => false,
        1 => true,
        _ => true,
      };
    }

    // MEMO(masaki): 想定外なのでログ出力する
    return defaultValue;
  }

  /// 現状の実装では利用を想定していないため [UnimplementedError] を返す。
  @override
  Object? toJson(bool value) {
    throw UnimplementedError();
  }
}
