/// 公式パッケージ内の同一名のものを応用した拡張機能。
extension EnumByName<T extends Enum> on Iterable<T> {
  /// [name] に一致する値若しくは null を返却する。
  ///
  /// 一致する値が見つからない場合、 [byName] のような [ArgumentError] ではなく null を返却するため、
  /// こういった場面を想定したハンドリングが可能になる。
  ///
  /// [name] が外部 API の仕様によるものでありこちらの制御化に無い場合など、値が一致しない状況が避けられない場面にて利用する。
  T? byNameOrNull(String? name) {
    for (final value in this) {
      if (value.name == name) {
        return value;
      }
    }
    return null;
  }
}
