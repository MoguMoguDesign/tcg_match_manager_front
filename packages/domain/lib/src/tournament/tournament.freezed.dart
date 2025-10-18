// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tournament.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Tournament {

/// トーナメント ID。
 String get id;/// トーナメントタイトル。
 String get title;/// トーナメントの説明。
 String? get description;/// カテゴリー。
 String? get category;/// 開催会場。
 String? get venue;/// トーナメント開始日時（ISO 8601 形式）。
 String? get startDate;/// トーナメント終了日時（ISO 8601 形式）。
 String? get endDate;/// 引き分け得点（0点 or 1点）。
 int get drawPoints;/// ラウンド数（自動計算時はnull）。
 int? get maxRounds;/// 予定参加者数（自動計算用）。
 int? get expectedPlayers;/// トーナメントステータス。
 String get status;/// 現在のラウンド番号。
 int get currentRound;/// 作成日時（ISO 8601 形式）。
 String get createdAt;/// 更新日時（ISO 8601 形式）。
 String get updatedAt;
/// Create a copy of Tournament
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TournamentCopyWith<Tournament> get copyWith => _$TournamentCopyWithImpl<Tournament>(this as Tournament, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Tournament&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.venue, venue) || other.venue == venue)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.drawPoints, drawPoints) || other.drawPoints == drawPoints)&&(identical(other.maxRounds, maxRounds) || other.maxRounds == maxRounds)&&(identical(other.expectedPlayers, expectedPlayers) || other.expectedPlayers == expectedPlayers)&&(identical(other.status, status) || other.status == status)&&(identical(other.currentRound, currentRound) || other.currentRound == currentRound)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,description,category,venue,startDate,endDate,drawPoints,maxRounds,expectedPlayers,status,currentRound,createdAt,updatedAt);

@override
String toString() {
  return 'Tournament(id: $id, title: $title, description: $description, category: $category, venue: $venue, startDate: $startDate, endDate: $endDate, drawPoints: $drawPoints, maxRounds: $maxRounds, expectedPlayers: $expectedPlayers, status: $status, currentRound: $currentRound, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $TournamentCopyWith<$Res>  {
  factory $TournamentCopyWith(Tournament value, $Res Function(Tournament) _then) = _$TournamentCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? description, String? category, String? venue, String? startDate, String? endDate, int drawPoints, int? maxRounds, int? expectedPlayers, String status, int currentRound, String createdAt, String updatedAt
});




}
/// @nodoc
class _$TournamentCopyWithImpl<$Res>
    implements $TournamentCopyWith<$Res> {
  _$TournamentCopyWithImpl(this._self, this._then);

  final Tournament _self;
  final $Res Function(Tournament) _then;

/// Create a copy of Tournament
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? category = freezed,Object? venue = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? drawPoints = null,Object? maxRounds = freezed,Object? expectedPlayers = freezed,Object? status = null,Object? currentRound = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,venue: freezed == venue ? _self.venue : venue // ignore: cast_nullable_to_non_nullable
as String?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String?,drawPoints: null == drawPoints ? _self.drawPoints : drawPoints // ignore: cast_nullable_to_non_nullable
as int,maxRounds: freezed == maxRounds ? _self.maxRounds : maxRounds // ignore: cast_nullable_to_non_nullable
as int?,expectedPlayers: freezed == expectedPlayers ? _self.expectedPlayers : expectedPlayers // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,currentRound: null == currentRound ? _self.currentRound : currentRound // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc


class _Tournament extends Tournament {
  const _Tournament({required this.id, required this.title, this.description, this.category, this.venue, this.startDate, this.endDate, this.drawPoints = 0, this.maxRounds, this.expectedPlayers, this.status = 'PREPARING', this.currentRound = 0, required this.createdAt, required this.updatedAt}): super._();
  

/// トーナメント ID。
@override final  String id;
/// トーナメントタイトル。
@override final  String title;
/// トーナメントの説明。
@override final  String? description;
/// カテゴリー。
@override final  String? category;
/// 開催会場。
@override final  String? venue;
/// トーナメント開始日時（ISO 8601 形式）。
@override final  String? startDate;
/// トーナメント終了日時（ISO 8601 形式）。
@override final  String? endDate;
/// 引き分け得点（0点 or 1点）。
@override@JsonKey() final  int drawPoints;
/// ラウンド数（自動計算時はnull）。
@override final  int? maxRounds;
/// 予定参加者数（自動計算用）。
@override final  int? expectedPlayers;
/// トーナメントステータス。
@override@JsonKey() final  String status;
/// 現在のラウンド番号。
@override@JsonKey() final  int currentRound;
/// 作成日時（ISO 8601 形式）。
@override final  String createdAt;
/// 更新日時（ISO 8601 形式）。
@override final  String updatedAt;

/// Create a copy of Tournament
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TournamentCopyWith<_Tournament> get copyWith => __$TournamentCopyWithImpl<_Tournament>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Tournament&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.venue, venue) || other.venue == venue)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.drawPoints, drawPoints) || other.drawPoints == drawPoints)&&(identical(other.maxRounds, maxRounds) || other.maxRounds == maxRounds)&&(identical(other.expectedPlayers, expectedPlayers) || other.expectedPlayers == expectedPlayers)&&(identical(other.status, status) || other.status == status)&&(identical(other.currentRound, currentRound) || other.currentRound == currentRound)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,description,category,venue,startDate,endDate,drawPoints,maxRounds,expectedPlayers,status,currentRound,createdAt,updatedAt);

@override
String toString() {
  return 'Tournament(id: $id, title: $title, description: $description, category: $category, venue: $venue, startDate: $startDate, endDate: $endDate, drawPoints: $drawPoints, maxRounds: $maxRounds, expectedPlayers: $expectedPlayers, status: $status, currentRound: $currentRound, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$TournamentCopyWith<$Res> implements $TournamentCopyWith<$Res> {
  factory _$TournamentCopyWith(_Tournament value, $Res Function(_Tournament) _then) = __$TournamentCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? description, String? category, String? venue, String? startDate, String? endDate, int drawPoints, int? maxRounds, int? expectedPlayers, String status, int currentRound, String createdAt, String updatedAt
});




}
/// @nodoc
class __$TournamentCopyWithImpl<$Res>
    implements _$TournamentCopyWith<$Res> {
  __$TournamentCopyWithImpl(this._self, this._then);

  final _Tournament _self;
  final $Res Function(_Tournament) _then;

/// Create a copy of Tournament
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? category = freezed,Object? venue = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? drawPoints = null,Object? maxRounds = freezed,Object? expectedPlayers = freezed,Object? status = null,Object? currentRound = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Tournament(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,venue: freezed == venue ? _self.venue : venue // ignore: cast_nullable_to_non_nullable
as String?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String?,drawPoints: null == drawPoints ? _self.drawPoints : drawPoints // ignore: cast_nullable_to_non_nullable
as int,maxRounds: freezed == maxRounds ? _self.maxRounds : maxRounds // ignore: cast_nullable_to_non_nullable
as int?,expectedPlayers: freezed == expectedPlayers ? _self.expectedPlayers : expectedPlayers // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,currentRound: null == currentRound ? _self.currentRound : currentRound // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
