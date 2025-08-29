import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// アプリで採用されるロケールを決定する。
///
/// app が intl パッケージへ依存することを防ぐために、このファイルで定義したものを [MaterialApp] 内で利用する。
Locale? localeListResolutionCallback(
  List<Locale>? locales,
  Iterable<Locale> supportedLocales,
) {
  // デバイスへの設定言語 (locales) とアプリの対応言語 (supportedLocales) から、利用される言語を決定する。
  // locales に設定された順序がまずは優先され、どの言語も該当しなかった場合には supportedLocales の先頭が利用される。
  final locale = basicLocaleListResolution(locales, supportedLocales);
  // DateFormat や NumberFormat へ反映するためにシステムのロケールを指定する
  Intl.systemLocale = locale.toString();
  return locale;
}
