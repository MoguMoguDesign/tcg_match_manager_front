import 'package:base_ui/src/l10n/l10n.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('lookupL10n のテスト。', () {
    test('サポートされているロケールで正しい型が返る。', () {
      expect(lookupL10n(const Locale('en')), isA<L10n>());
      expect(lookupL10n(const Locale('ja')), isA<L10n>());
    });

    test('未サポートのロケールでは FlutterError がスローされる。', () {
      expect(
        () => lookupL10n(const Locale('fr')),
        throwsA(isA<FlutterError>()),
      );
    });
  });
}
