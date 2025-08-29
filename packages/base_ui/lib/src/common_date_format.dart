import 'package:intl/intl.dart';

/// アプリで共通して利用される [DateFormat].
///
/// [DateTime] を特定のフォーマットへ整形された文字列へ変換する際に、
/// [CommonDateFormat.formatYMMMd] のように static メソッドへアクセスして利用する。
///
/// ja ロケールの場合、以下の表にあるように整形される。
/// https://github.com/dart-archive/intl/blob/eb4ab704c4a3c48d957b2a188c6b452051a093a7/lib/date_time_patterns.dart#L2707
abstract final class CommonDateFormat {
  // MEMO(masaki): 現状利用箇所の想定が無いサンプル実装のため、不要なら削除する
  /// [dateTime] をロケールに応じて yMMMd 形式の文字列に整形して返す。
  ///
  /// ロケールが ja の場合、`y年M月d日` のように整形される。
  static String formatYMMMd(DateTime dateTime) {
    return DateFormat.yMMMd().format(dateTime);
  }

  // MEMO(masaki): 本棚の詳細アイテム内での表記に使う想定
  /// [dateTime] をロケールに応じて yMd と Hms 形式を合算した文字列に整形して返す。
  ///
  /// ロケールが ja の場合、`y/M/d H:mm:ss` のように整形される。
  static String formatYMdHms(DateTime dateTime) {
    return DateFormat.yMd().add_Hms().format(dateTime);
  }
}
