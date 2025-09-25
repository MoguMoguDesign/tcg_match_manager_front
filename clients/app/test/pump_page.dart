import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 指定した横幅でページウィジェットを描画する。
///
/// [page] を [width] で指定した横幅の [MediaQuery] 内に配置し、
/// テスト用の [WidgetTester] で描画する。
///
/// テスト環境でページのレイアウトや表示を検証する際に利用する。
Future<void> pumpPage(
  WidgetTester tester,
  Widget page, {
  double width = 400,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: Size(width, 800)),
          child: page,
        ),
      ),
    ),
  );
}
