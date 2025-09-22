// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:admin/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// 管理画面アプリのスモークテストを実行する。
///
/// ログインページが正しく表示されるかどうかを検証する。
void main() {
  testWidgets('ログインページが初期表示される', (tester) async {
    // 画面サイズを十分な大きさに設定する。
    final view = tester.view;
    view.physicalSize = const Size(1280, 1024);
    view.devicePixelRatio = 1.0;
    addTearDown(() {
      view.resetPhysicalSize();
      view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('管理者アカウントでログイン'), findsOneWidget);
    expect(find.text('ログイン'), findsOneWidget);
  });
}
