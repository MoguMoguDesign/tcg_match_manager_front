import 'package:app/pages/login_page.dart';
import 'package:base_ui/base_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../pump_page.dart';

void main() {
  group('バリデーションのテストグループ。', () {
    testWidgets('サーバー URL が空の状態でログインボタンをタップするとエラーが表示される。', (
      WidgetTester tester,
    ) async {
      // ログインページを描画する。
      await pumpPage(tester, const LoginPage());

      // context から L10n インスタンスを取得する。
      final BuildContext context = tester.element(find.byType(LoginPage));
      final l10n = L10n.of(context);

      // ユーザー名のテキストフィールドにテキストを入力する。
      await tester.enterText(find.byKey(LoginPage.userNameTextFieldKey), 'a');

      // サーバー URL のテキストフィールドは空のままにする。

      // ログインボタンをタップする。
      await tester.tap(
        find.widgetWithText(CommonElevatedButton, l10n.buttonLogin),
      );
      // ダイアログが表示され、アニメーションが完了するまで待機する。
      await tester.pumpAndSettle();

      // サーバー URL のテキストフィールド下にエラーメッセージが表示されることを検証する。
      expect(find.text(l10n.messageEmpty), findsOneWidget);

      // CommonAlertDialog が正しいメッセージで表示されることを検証する。
      expect(find.byType(CommonAlertDialog), findsOneWidget);
      expect(find.text(l10n.messageInvalidTextInput), findsOneWidget);
    });

    testWidgets('ユーザー名が空の状態でログインボタンをタップするとエラーが表示される。', (
      WidgetTester tester,
    ) async {
      // ログインページを描画する。
      await pumpPage(tester, const LoginPage());

      // context から L10n インスタンスを取得する。
      final BuildContext context = tester.element(find.byType(LoginPage));
      final l10n = L10n.of(context);

      // サーバー URL にテキストを入力する。
      await tester.enterText(find.byKey(LoginPage.serverUrlTextFieldKey), 'a');

      // ユーザー名のテキストフィールドは空のままにする。

      // ログインボタンをタップする。
      await tester.tap(
        find.widgetWithText(CommonElevatedButton, l10n.buttonLogin),
      );
      // ダイアログが表示され、アニメーションが完了するまで待機する。
      await tester.pumpAndSettle();

      // ユーザー名のテキストフィールド下にエラーメッセージが表示されることを検証する。
      expect(find.text(l10n.messageEmpty), findsOneWidget);

      // CommonAlertDialog が正しいメッセージで表示されることを検証する。
      expect(find.byType(CommonAlertDialog), findsOneWidget);
      expect(find.text(l10n.messageInvalidTextInput), findsOneWidget);
    });
  });
}
