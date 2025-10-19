import 'dart:async';

import 'package:base_ui/base_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../router.dart';

/// ログインリストページを表示する。
///
/// 参加者のニックネームを選択し、トーナメントに復帰する導線を提供する。
class LoginListPage extends ConsumerStatefulWidget {
  /// [LoginListPage] のコンストラクタ。
  const LoginListPage({super.key});

  @override
  ConsumerState<LoginListPage> createState() => _LoginListPageState();
}

class _LoginListPageState extends ConsumerState<LoginListPage> {
  String? selectedPlayer;
  List<Player> players = [];
  bool isLoadingPlayers = false;
  String? playersError;

  // 旧ボトムシート UI は DropdownSelectField に置換済みのため削除。

  @override
  void initState() {
    super.initState();
    // トーナメント情報とプレイヤーリストを取得する。
    // TODO(user): tournamentId は QR コードスキャンまたは
    // ルートパラメータから取得する。
    const tournamentId = 'tournament-001';
    unawaited(
      ref
          .read(tournamentDetailNotifierProvider.notifier)
          .loadTournament(tournamentId),
    );
    unawaited(_loadPlayers(tournamentId));
  }

  /// プレイヤーリストを取得する。
  Future<void> _loadPlayers(String tournamentId) async {
    setState(() {
      isLoadingPlayers = true;
      playersError = null;
    });

    try {
      final getRegisteredPlayersUseCase =
          ref.read(getRegisteredPlayersUseCaseProvider);
      final result =
          await getRegisteredPlayersUseCase.invoke(tournamentId: tournamentId);
      setState(() {
        players = result;
        isLoadingPlayers = false;
      });
    } on GeneralFailureException catch (e) {
      setState(() {
        playersError = 'プレイヤーリストの取得に失敗しました: ${e.reason.name}';
        isLoadingPlayers = false;
      });
    } on Exception catch (e) {
      setState(() {
        playersError = 'プレイヤーリストの取得に失敗しました: $e';
        isLoadingPlayers = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tournamentDetailState = ref.watch(tournamentDetailNotifierProvider);
    return Scaffold(
      body: SvgBackground(
        assetPath: 'packages/base_ui/assets/images/login_background.svg',
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    children: [
                      const SizedBox(height: 135),
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
                      if (tournamentDetailState.state ==
                          TournamentDetailState.loaded)
                        TournamentInfoCard(
                          title: tournamentDetailState.tournament!.title,
                          date:
                              tournamentDetailState.tournament!.startDate ?? '',
                          participantCount:
                              tournamentDetailState.tournament!.playerCount ??
                                  0,
                        )
                      else if (tournamentDetailState.state ==
                          TournamentDetailState.loading)
                        const SizedBox(
                          height: 100,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else if (tournamentDetailState.state ==
                          TournamentDetailState.error)
                        Container(
                          height: 100,
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: Text(
                              tournamentDetailState.errorMessage ??
                                  'エラーが発生しました',
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
                      // 選択フォーム（共通コンポーネントへ置換）
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '参加者リストからあなたの\nニックネームを選んでください',
                            style: AppTextStyles.labelMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'ニックネーム',
                            style: AppTextStyles.labelMedium,
                          ),
                          const SizedBox(height: 9),
                          if (isLoadingPlayers)
                            const Center(
                              child: CircularProgressIndicator(),
                            )
                          else if (playersError != null)
                            Text(
                              playersError!,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.red,
                              ),
                            )
                          else
                            DropdownSelectField<String>(
                              hintText: selectedPlayer ?? 'リストから選択',
                              items: players.map((p) => p.name).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedPlayer = value;
                                });
                              },
                            ),
                          const SizedBox(height: 16),
                          CommonConfirmButton(
                            text: 'トーナメントに復帰する',
                            onPressed: () {
                              context.goToMatchingTable();
                            },
                            isEnabled: selectedPlayer != null,
                          ),
                        ],
                      ),
                      const SizedBox(height: 80),
                      // 登録に戻る
                      CommonSmallButton(
                        text: '参加登録に戻る',
                        onPressed: () {
                          context.goToRegistration();
                        },
                        style: SmallButtonStyle.secondary,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
