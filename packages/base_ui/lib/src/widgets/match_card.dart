// Match機能が実装されるまで一時的にコメントアウト
// import 'package:domain/domain.dart';
// import 'package:flutter/material.dart';
//
// import '../constants/app_colors.dart';
// import '../constants/app_text_styles.dart';
//
// /// マッチ情報を表示するカードウィジェット。
// ///
// /// テーブル番号、プレイヤー情報、対戦状況を表示し、
// /// 結果入力のタップイベントをサポートする。
// class MatchCard extends StatelessWidget {
//   /// [MatchCard]のコンストラクタ。
//   ///
//   /// [match]は表示するマッチ情報で必須パラメータ。
//   /// [onResultTap]は結果入力時のコールバック。
//   const MatchCard({super.key, required this.match, this.onResultTap});
//
//   /// 表示するマッチの情報。
//   final Match match;
//
//   /// 結果入力ボタンタップ時のコールバック。
//   final VoidCallback? onResultTap;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       child: Row(
//         children: [
//           // テーブル番号とステータス
//           Column(
//             children: [
//               Text('${match.tableNumber}卓',
//                style: AppTextStyles.labelMedium),
//               const SizedBox(height: 3),
//               Container(
//                 padding: const EdgeInsets.
//                            symmetric(horizontal: 8, vertical: 2),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(4),
//                   border: Border.all(
//                     color: match.status == MatchStatus.ongoing
//                         ? AppColors.userPrimary
//                         : AppColors.whiteAlpha,
//                   ),
//                 ),
//                 child: Text(
//                   match.status == MatchStatus.ongoing ? '対戦中' : '終了',
//                   style: AppTextStyles.labelSmall.copyWith(
//                     color: match.status == MatchStatus.ongoing
//                         ? AppColors.userPrimary
//                         : AppColors.white,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(width: 8),
//           // 対戦カード
//           Expanded(
//             child: Row(
//               children: [
//                 // プレイヤー1
//                 Expanded(
//                   child: _buildPlayerCard(
//                     match.player1,
//                     match.winner == match.player1,
//                     isLeft: true,
//                   ),
//                 ),
//                 // VS表示
//                 Container(
//                   width: 20,
//                   height: 57,
//                   decoration: const BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors:
//                        [AppColors.userPrimary, AppColors.adminPrimary],
//                     ),
//                   ),
//                   child: Center(
//                     child: Text(
//                       'vs',
//                       style: AppTextStyles.bodySmall.copyWith(
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//                 // プレイヤー2
//                 Expanded(
//                   child: _buildPlayerCard(
//                     match.player2,
//                     match.winner == match.player2,
//                     isLeft: false,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// プレイヤー情報を表示するカードを構築する。
//   ///
//   /// [player]はプレイヤー情報、[isWinner]は勝者かどうか、
//   /// [isLeft]は左側配置かどうかを指定する。
//   Widget _buildPlayerCard(
//     Player player,
//     bool isWinner, {
//     required bool isLeft,
//   }) {
//     Color backgroundColor;
//     String? resultText;
//
//     if (match.status == MatchStatus.completed) {
//       if (isWinner) {
//         backgroundColor = player.isCurrentPlayer
//             ? AppColors.userPrimaryAlpha
//             : AppColors.userPrimaryAlpha;
//         resultText = 'WIN';
//       } else {
//         backgroundColor = player.isCurrentPlayer
//             ? AppColors.adminPrimaryAlpha
//             : AppColors.adminPrimaryAlpha;
//         resultText = 'LOSE';
//       }
//     } else {
//       backgroundColor = player.isCurrentPlayer
//           ? AppColors.adminPrimary
//           : AppColors.textBlack;
//     }
//
//     return Container(
//       height: 57,
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: backgroundColor,
//         borderRadius: isLeft
//             ? const BorderRadius.only(
//                 topLeft: Radius.circular(4),
//                 bottomLeft: Radius.circular(4),
//               )
//             : const BorderRadius.only(
//                 topRight: Radius.circular(4),
//                 bottomRight: Radius.circular(4),
//               ),
//       ),
//       child: Stack(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 player.name,
//                 style: AppTextStyles.labelMedium.copyWith(fontSize: 14),
//                 overflow: TextOverflow.ellipsis,
//               ),
//               Text('累計得点 ${player.score}点', style: AppTextStyles.bodySmall),
//             ],
//           ),
//           if (resultText != null)
//             Positioned(
//               right: isLeft ? 0 : null,
//               left: isLeft ? null : 0,
//               top: 0,
//               bottom: 0,
//               child: Center(
//                 child: Text(
//                   resultText,
//                   style: AppTextStyles.headlineLarge.copyWith(
//                     color: AppColors.whiteAlpha,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
