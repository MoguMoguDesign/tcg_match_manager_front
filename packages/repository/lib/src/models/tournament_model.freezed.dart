// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tournament_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TournamentModel {

/// 大会 ID。
 String get id;/// 大会タイトル。
@JsonKey(name: 'name') String get title;/// 大会の説明。
@JsonKey(name: 'overview') String? get description;/// 大会カテゴリ。
 String? get category;/// 開催会場。
 String? get venue;/// 大会開始日時（ISO 8601 形式）。
@JsonKey(name: 'date') String? get startDate;/// 大会終了日時（ISO 8601 形式）。
 String? get endDate;/// 引き分け得点（0点 or 1点）。
 int get drawPoints;/// ラウンド数。
@JsonKey(name: 'maxRound') int? get maxRounds;/// 予定参加者数。
 int? get expectedPlayers;/// トーナメントステータス。
 String get status;/// 現在のラウンド番号。
@JsonKey(name: 'currentRound') int get currentRound;/// スケジュールモード。
@JsonKey(name: 'scheduleMode') String? get scheduleMode;/// プレイヤー数。
@JsonKey(name: 'playerCount') int? get playerCount;/// 管理者UID。
@JsonKey(name: 'adminUid') String? get adminUid;/// 作成日時（ISO 8601 形式）。
@JsonKey(name: 'createdAt') String get createdAt;/// 更新日時（ISO 8601 形式）。
@JsonKey(name: 'updatedAt') String get updatedAt;
/// Create a copy of TournamentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TournamentModelCopyWith<TournamentModel> get copyWith => _$TournamentModelCopyWithImpl<TournamentModel>(this as TournamentModel, _$identity);

  /// Serializes this TournamentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TournamentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.venue, venue) || other.venue == venue)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.drawPoints, drawPoints) || other.drawPoints == drawPoints)&&(identical(other.maxRounds, maxRounds) || other.maxRounds == maxRounds)&&(identical(other.expectedPlayers, expectedPlayers) || other.expectedPlayers == expectedPlayers)&&(identical(other.status, status) || other.status == status)&&(identical(other.currentRound, currentRound) || other.currentRound == currentRound)&&(identical(other.scheduleMode, scheduleMode) || other.scheduleMode == scheduleMode)&&(identical(other.playerCount, playerCount) || other.playerCount == playerCount)&&(identical(other.adminUid, adminUid) || other.adminUid == adminUid)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,category,venue,startDate,endDate,drawPoints,maxRounds,expectedPlayers,status,currentRound,scheduleMode,playerCount,adminUid,createdAt,updatedAt);

@override
String toString() {
  return 'TournamentModel(id: $id, title: $title, description: $description, category: $category, venue: $venue, startDate: $startDate, endDate: $endDate, drawPoints: $drawPoints, maxRounds: $maxRounds, expectedPlayers: $expectedPlayers, status: $status, currentRound: $currentRound, scheduleMode: $scheduleMode, playerCount: $playerCount, adminUid: $adminUid, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $TournamentModelCopyWith<$Res>  {
  factory $TournamentModelCopyWith(TournamentModel value, $Res Function(TournamentModel) _then) = _$TournamentModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'name') String title,@JsonKey(name: 'overview') String? description, String? category, String? venue,@JsonKey(name: 'date') String? startDate, String? endDate, int drawPoints,@JsonKey(name: 'maxRound') int? maxRounds, int? expectedPlayers, String status,@JsonKey(name: 'currentRound') int currentRound,@JsonKey(name: 'scheduleMode') String? scheduleMode,@JsonKey(name: 'playerCount') int? playerCount,@JsonKey(name: 'adminUid') String? adminUid,@JsonKey(name: 'createdAt') String createdAt,@JsonKey(name: 'updatedAt') String updatedAt
});




}
/// @nodoc
class _$TournamentModelCopyWithImpl<$Res>
    implements $TournamentModelCopyWith<$Res> {
  _$TournamentModelCopyWithImpl(this._self, this._then);

  final TournamentModel _self;
  final $Res Function(TournamentModel) _then;

/// Create a copy of TournamentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? category = freezed,Object? venue = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? drawPoints = null,Object? maxRounds = freezed,Object? expectedPlayers = freezed,Object? status = null,Object? currentRound = null,Object? scheduleMode = freezed,Object? playerCount = freezed,Object? adminUid = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
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
as int,scheduleMode: freezed == scheduleMode ? _self.scheduleMode : scheduleMode // ignore: cast_nullable_to_non_nullable
as String?,playerCount: freezed == playerCount ? _self.playerCount : playerCount // ignore: cast_nullable_to_non_nullable
as int?,adminUid: freezed == adminUid ? _self.adminUid : adminUid // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _TournamentModel implements TournamentModel {
  const _TournamentModel({required this.id, @JsonKey(name: 'name') required this.title, @JsonKey(name: 'overview') this.description, this.category, this.venue, @JsonKey(name: 'date') this.startDate, this.endDate, this.drawPoints = 0, @JsonKey(name: 'maxRound') this.maxRounds, this.expectedPlayers, this.status = 'PREPARING', @JsonKey(name: 'currentRound') this.currentRound = 0, @JsonKey(name: 'scheduleMode') this.scheduleMode, @JsonKey(name: 'playerCount') this.playerCount, @JsonKey(name: 'adminUid') this.adminUid, @JsonKey(name: 'createdAt') required this.createdAt, @JsonKey(name: 'updatedAt') required this.updatedAt});
  factory _TournamentModel.fromJson(Map<String, dynamic> json) => _$TournamentModelFromJson(json);

/// 大会 ID。
@override final  String id;
/// 大会タイトル。
@override@JsonKey(name: 'name') final  String title;
/// 大会の説明。
@override@JsonKey(name: 'overview') final  String? description;
/// 大会カテゴリ。
@override final  String? category;
/// 開催会場。
@override final  String? venue;
/// 大会開始日時（ISO 8601 形式）。
@override@JsonKey(name: 'date') final  String? startDate;
/// 大会終了日時（ISO 8601 形式）。
@override final  String? endDate;
/// 引き分け得点（0点 or 1点）。
@override@JsonKey() final  int drawPoints;
/// ラウンド数。
@override@JsonKey(name: 'maxRound') final  int? maxRounds;
/// 予定参加者数。
@override final  int? expectedPlayers;
/// トーナメントステータス。
@override@JsonKey() final  String status;
/// 現在のラウンド番号。
@override@JsonKey(name: 'currentRound') final  int currentRound;
/// スケジュールモード。
@override@JsonKey(name: 'scheduleMode') final  String? scheduleMode;
/// プレイヤー数。
@override@JsonKey(name: 'playerCount') final  int? playerCount;
/// 管理者UID。
@override@JsonKey(name: 'adminUid') final  String? adminUid;
/// 作成日時（ISO 8601 形式）。
@override@JsonKey(name: 'createdAt') final  String createdAt;
/// 更新日時（ISO 8601 形式）。
@override@JsonKey(name: 'updatedAt') final  String updatedAt;

/// Create a copy of TournamentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TournamentModelCopyWith<_TournamentModel> get copyWith => __$TournamentModelCopyWithImpl<_TournamentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TournamentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TournamentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.venue, venue) || other.venue == venue)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.drawPoints, drawPoints) || other.drawPoints == drawPoints)&&(identical(other.maxRounds, maxRounds) || other.maxRounds == maxRounds)&&(identical(other.expectedPlayers, expectedPlayers) || other.expectedPlayers == expectedPlayers)&&(identical(other.status, status) || other.status == status)&&(identical(other.currentRound, currentRound) || other.currentRound == currentRound)&&(identical(other.scheduleMode, scheduleMode) || other.scheduleMode == scheduleMode)&&(identical(other.playerCount, playerCount) || other.playerCount == playerCount)&&(identical(other.adminUid, adminUid) || other.adminUid == adminUid)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,category,venue,startDate,endDate,drawPoints,maxRounds,expectedPlayers,status,currentRound,scheduleMode,playerCount,adminUid,createdAt,updatedAt);

@override
String toString() {
  return 'TournamentModel(id: $id, title: $title, description: $description, category: $category, venue: $venue, startDate: $startDate, endDate: $endDate, drawPoints: $drawPoints, maxRounds: $maxRounds, expectedPlayers: $expectedPlayers, status: $status, currentRound: $currentRound, scheduleMode: $scheduleMode, playerCount: $playerCount, adminUid: $adminUid, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$TournamentModelCopyWith<$Res> implements $TournamentModelCopyWith<$Res> {
  factory _$TournamentModelCopyWith(_TournamentModel value, $Res Function(_TournamentModel) _then) = __$TournamentModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'name') String title,@JsonKey(name: 'overview') String? description, String? category, String? venue,@JsonKey(name: 'date') String? startDate, String? endDate, int drawPoints,@JsonKey(name: 'maxRound') int? maxRounds, int? expectedPlayers, String status,@JsonKey(name: 'currentRound') int currentRound,@JsonKey(name: 'scheduleMode') String? scheduleMode,@JsonKey(name: 'playerCount') int? playerCount,@JsonKey(name: 'adminUid') String? adminUid,@JsonKey(name: 'createdAt') String createdAt,@JsonKey(name: 'updatedAt') String updatedAt
});




}
/// @nodoc
class __$TournamentModelCopyWithImpl<$Res>
    implements _$TournamentModelCopyWith<$Res> {
  __$TournamentModelCopyWithImpl(this._self, this._then);

  final _TournamentModel _self;
  final $Res Function(_TournamentModel) _then;

/// Create a copy of TournamentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? category = freezed,Object? venue = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? drawPoints = null,Object? maxRounds = freezed,Object? expectedPlayers = freezed,Object? status = null,Object? currentRound = null,Object? scheduleMode = freezed,Object? playerCount = freezed,Object? adminUid = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_TournamentModel(
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
as int,scheduleMode: freezed == scheduleMode ? _self.scheduleMode : scheduleMode // ignore: cast_nullable_to_non_nullable
as String?,playerCount: freezed == playerCount ? _self.playerCount : playerCount // ignore: cast_nullable_to_non_nullable
as int?,adminUid: freezed == adminUid ? _self.adminUid : adminUid // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
