import 'dart:async';

import 'package:base_ui/base_ui.dart';
import 'package:domain/domain.dart' as domain;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../router.dart';

/// 試合結果入力ページを表示する。
///
/// 対戦の勝敗を入力し、次のラウンドへ進む操作を提供する。
class ResultEntryPage extends HookConsumerWidget {
  /// [ResultEntryPage] のコンストラクタ。
  const ResultEntryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);

    // UseCase、Notifier、セッション情報を取得する。
    final submitMatchResultUseCase =
        ref.read(domain.submitMatchResultUseCaseProvider);
    final matchListNotifier =
        ref.read(domain.matchListNotifierProvider.notifier);
    final matchListState = ref.watch(domain.matchListNotifierProvider);
    final sessionState = ref.watch(domain.playerSessionNotifierProvider);

    // 自分のマッチを取得する。
    final myMatch = matchListState.value?.firstWhere(
      (match) => match.isMine,
      orElse: () => throw Exception('自分のマッチが見つかりません'),
    );

    /// 結果を送信する。
    Future<void> submitResult({
      required String resultType,
      required String? winnerId,
    }) async {
      final session = sessionState;
      if (myMatch == null) {
        return;
      }

      isLoading.value = true;

      try {
        // TODO(user): baseUrl と roundId は QR コードスキャンまたは
        // ルートパラメータから取得する。
        const baseUrl = 'https://example.com/';
        await submitMatchResultUseCase.invoke(
          baseUrl: baseUrl,
          tournamentId: session.tournamentId,
          roundId: 'round-1',
          matchId: myMatch.id,
          resultType: resultType,
          winnerId: winnerId ?? '',
          userId: session.userId,
        );

        // 結果送信後、マッチリストを更新する。
        await matchListNotifier.fetchMatches(
          baseUrl: baseUrl,
          tournamentId: session.tournamentId,
          roundId: 'round-1',
          userId: session.userId,
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '結果が登録されました',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textBlack,
                ),
              ),
              backgroundColor: AppColors.userPrimary,
            ),
          );
          context.goToMatchingTable();
        }
      } on domain.GeneralFailureException catch (e) {
        if (context.mounted) {
          final errorMessage = switch (e.reason) {
            domain.GeneralFailureReason.noConnectionError =>
              'ネットワーク接続エラーが発生しました',
            domain.GeneralFailureReason.serverUrlNotFoundError =>
              'サーバーが見つかりません',
            _ => '結果の送信に失敗しました',
          };

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                errorMessage,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.white,
                ),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      } on domain.FailureStatusException catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                e.message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.white,
                ),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        isLoading.value = false;
      }
    }
    /// 確認ダイアログを表示する。
    void showConfirmDialog({
      required String resultLabel,
      required String resultType,
      required String? winnerId,
    }) {
      unawaited(
        ConfirmDialog.show(
          context,
          title: '結果確認',
          message: '$resultLabelで登録しますか？',
          confirmText: '確定',
          onConfirm: () {
            context.pop(); // ダイアログを閉じる
            if (!context.mounted) {
              return;
            }
            unawaited(
              submitResult(
                resultType: resultType,
                winnerId: winnerId,
              ),
            );
          },
        ),
      );
    }

    // 背景テーマは Svg 背景へ統一。
    return Theme(
      data: Theme.of(context).copyWith(
        extensions: const <ThemeExtension<dynamic>>[kDefaultBackgroundGradient],
      ),
      child: SvgBackground(
        assetPath: 'packages/base_ui/assets/images/whole_background.svg',
        child: CommonScaffold(
          appbarText: '勝敗登録',
          enableHorizontalPadding: false,
          enableScrollView: false,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Spacer(),
                // 説明テキスト
                Column(
                  children: [
                    Text(
                      '※ あなたの結果を入力してください',
                      style: AppTextStyles.labelMedium.copyWith(fontSize: 14),
                    ),
                    Text(
                      '※ 勝者が入力してください',
                      style: AppTextStyles.labelMedium.copyWith(fontSize: 14),
                    ),
                  ],
                ),
                const Spacer(flex: 2),
                // ボタン群
                Column(
                  children: [
                    CommonConfirmButton(
                      text: isLoading.value ? '送信中...' : '勝利',
                      width: 342,
                      isEnabled: !isLoading.value && myMatch != null,
                      onPressed: () {
                        if (myMatch == null) {
                          return;
                        }
                        // 自分の側に応じて勝者IDを設定する。
                        final myPlayerId = myMatch.meSide == 'player1'
                            ? myMatch.player1.id
                            : myMatch.player2.id;
                        final resultType = myMatch.meSide == 'player1'
                            ? 'PLAYER1_WIN'
                            : 'PLAYER2_WIN';
                        showConfirmDialog(
                          resultLabel: '勝利',
                          resultType: resultType,
                          winnerId: myPlayerId,
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    CommonConfirmButton(
                      text: isLoading.value ? '送信中...' : '引き分け(両者敗北)',
                      width: 342,
                      style: ConfirmButtonStyle.userOutlined,
                      isEnabled: !isLoading.value && myMatch != null,
                      onPressed: () {
                        showConfirmDialog(
                          resultLabel: '引き分け',
                          resultType: 'BOTH_LOSS',
                          winnerId: null,
                        );
                      },
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
