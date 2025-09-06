import 'package:base_ui/base_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CommonConfirmButton の基本動作。', () {
    testWidgets('ユーザー塗りつぶしスタイルでレンダリングされる。', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonConfirmButton(
              text: '参加に進む',
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('参加に進む'), findsOneWidget);
      await tester.tap(find.text('参加に進む'));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('管理者アウトラインスタイルでレンダリングされる。', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CommonConfirmButton(
              text: 'ログイン',
              style: ConfirmButtonStyle.adminOutlined,
              onPressed: _noop,
            ),
          ),
        ),
      );

      expect(find.text('ログイン'), findsOneWidget);
    });
  });
}

void _noop() {}
