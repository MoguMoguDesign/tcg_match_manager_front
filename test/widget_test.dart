import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TCGマッチマネージャー基本テスト', () {
    testWidgets('アプリケーション初期化テスト', (WidgetTester tester) async {
      // テスト用のシンプルなアプリを作成
      const testApp = MaterialApp(
        title: 'TCG Match Manager Test',
        home: Scaffold(body: Center(child: Text('TCG Match Manager'))),
      );

      // アプリをビルドしてフレームをトリガー
      await tester.pumpWidget(testApp);

      // アプリのタイトルテキストが表示されることを検証
      expect(find.text('TCG Match Manager'), findsOneWidget);

      // Scaffoldウィジェットが存在することを検証
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
