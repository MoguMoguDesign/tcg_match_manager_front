import 'dart:async';

import 'package:base_ui/base_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../router.dart';

/// 参加者登録ページを表示する。
///
/// ニックネームの入力とトーナメントへの参加登録を行う。
class RegistrationPage extends HookConsumerWidget {
  /// [RegistrationPage] のコンストラクタ。
  ///
  /// - [tournamentId] は、トーナメントID。
  const RegistrationPage({super.key, this.tournamentId});

  /// トーナメントID。
  final String? tournamentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nicknameController = useTextEditingController();
    final isLoading = useState(false);
    final nickname = useState('');

    // UseCase と Notifier を取得する。
    final registerPlayerUseCase = ref.read(registerPlayerUseCaseProvider);
    final playerSessionNotifier = ref.read(
      playerSessionNotifierProvider.notifier,
    );
    final tournamentDetailNotifier = ref.read(
      tournamentDetailNotifierProvider.notifier,
    );
    final tournamentDetailState = ref.watch(tournamentDetailNotifierProvider);

    // 初回ロード時にトーナメント情報を取得する。
    useEffect(() {
      final id = tournamentId ?? 'tournament-001';
      unawaited(tournamentDetailNotifier.loadTournament(id));
      return null;
    }, [tournamentId]);

    /// プレイヤー登録処理を実行する。
    Future<void> handleRegister() async {
      if (nickname.value.trim().isEmpty) {
        return;
      }

      isLoading.value = true;

      try {
        // TODO(user): baseUrl と tournamentId は QR コードスキャンまたは
        // ルートパラメータから取得する。
        const baseUrl = 'https://example.com/';
        const tournamentId = 'tournament-001';

        // プレイヤー登録を実行する。
        final session = await registerPlayerUseCase.invoke(
          baseUrl: baseUrl,
          tournamentId: tournamentId,
          playerName: nickname.value.trim(),
        );

        // セッション情報を保存する。
        await playerSessionNotifier.saveSession(session);

        // 登録成功時の処理。
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '登録が完了しました（${session.playerName}）',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textBlack,
                ),
              ),
              backgroundColor: AppColors.userPrimary,
            ),
          );
          context.goToPreTournament();
        }
      } on GeneralFailureException catch (e) {
        // エラーハンドリング。
        if (context.mounted) {
          final errorMessage = switch (e.reason) {
            GeneralFailureReason.noConnectionError => 'ネットワーク接続エラーが発生しました',
            GeneralFailureReason.serverUrlNotFoundError => 'サーバーが見つかりません',
            _ => '登録に失敗しました',
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
      } on FailureStatusException catch (e) {
        // API エラー。
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

    return Scaffold(
      body: SvgBackground(
        assetPath: 'packages/base_ui/assets/images/login_background.svg',
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      context.goToComponentTest();
                    },
                    icon: const Icon(
                      Icons.settings,
                      color: AppColors.white,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(height: 95),
                // ロゴ
                Container(
                  height: 28,
                  width: 139,
                  alignment: Alignment.center,
                  child: Text(
                    'マチサポ',
                    style: AppTextStyles.headlineLarge.copyWith(
                      color: AppColors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(height: 59),
                // トーナメント情報カード
                if (tournamentDetailState.state == TournamentDetailState.loaded)
                  TournamentInfoCard(
                    title: tournamentDetailState.tournament!.title,
                    date: tournamentDetailState.tournament!.startDate ?? '',
                    participantCount:
                        tournamentDetailState.tournament!.playerCount ?? 0,
                  )
                else if (tournamentDetailState.state ==
                    TournamentDetailState.loading)
                  const SizedBox(
                    height: 100,
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (tournamentDetailState.state ==
                    TournamentDetailState.error)
                  Container(
                    height: 100,
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                        tournamentDetailState.errorMessage ?? 'エラーが発生しました',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 100),
                const SizedBox(height: 32),
                // 入力フォーム
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '大会で表示するニックネームを入力してください',
                      style: AppTextStyles.labelMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text('ニックネーム', style: AppTextStyles.labelMedium),
                    const SizedBox(height: 9),
                    FigmaTextField(
                      controller: nicknameController,
                      hintText: 'ニックネームを入力',
                      onChanged: (value) {
                        nickname.value = value;
                      },
                    ),
                    const SizedBox(height: 16),
                    CommonConfirmButton(
                      text: isLoading.value ? '登録中...' : '参加に進む',
                      onPressed: () {
                        unawaited(handleRegister());
                      },
                      isEnabled:
                          nickname.value.trim().isNotEmpty && !isLoading.value,
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // 接続問題の場合
                Column(
                  children: [
                    Text(
                      '接続が切れましたか？',
                      style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    CommonSmallButton(
                      text: 'トーナメントに復帰する',
                      onPressed: () {
                        context.goToLoginList();
                      },
                      style: SmallButtonStyle.secondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
