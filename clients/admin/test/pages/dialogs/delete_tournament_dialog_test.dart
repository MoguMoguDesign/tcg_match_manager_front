import 'package:admin/pages/dialogs/delete_tournament_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DeleteTournamentDialog', () {
    testWidgets('大会削除確認ダイアログが正しく表示される', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    await showDeleteTournamentDialog(
                      context,
                      tournamentTitle: 'テスト大会',
                    );
                  },
                  child: const Text('Open Dialog'),
                );
              },
            ),
          ),
        ),
      );

      // ボタンをタップしてダイアログを表示
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // ダイアログの要素が表示されていることを確認
      expect(find.text('本当にこの大会を削除しますか？'), findsOneWidget);
      expect(find.text('テスト大会'), findsOneWidget);
      expect(find.text('キャンセル'), findsOneWidget);
      expect(find.text('削除'), findsOneWidget);
    });

    testWidgets('キャンセルボタンをタップすると false が返される', (tester) async {
      bool? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    result = await showDeleteTournamentDialog(
                      context,
                      tournamentTitle: 'テスト大会',
                    );
                  },
                  child: const Text('Open Dialog'),
                );
              },
            ),
          ),
        ),
      );

      // ボタンをタップしてダイアログを表示
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // キャンセルボタンをタップ
      await tester.tap(find.text('キャンセル'));
      await tester.pumpAndSettle();

      // false が返されることを確認
      expect(result, false);
    });

    testWidgets('削除ボタンをタップすると true が返される', (tester) async {
      bool? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    result = await showDeleteTournamentDialog(
                      context,
                      tournamentTitle: 'テスト大会',
                    );
                  },
                  child: const Text('Open Dialog'),
                );
              },
            ),
          ),
        ),
      );

      // ボタンをタップしてダイアログを表示
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // 削除ボタンをタップ
      await tester.tap(find.text('削除'));
      await tester.pumpAndSettle();

      // true が返されることを確認
      expect(result, true);
    });
  });
}
