// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_tournament_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateTournamentRequest {

/// 大会タイトル。
 String get title;/// 大会の説明。
 String get description;/// 開催会場。
 String get venue;/// 大会開始日時（ISO 8601 形式）。
 String get startDate;/// 大会終了日時（ISO 8601 形式）。
 String get endDate;/// 引き分け得点（0点 or 1点）。
 int get drawPoints;/// ラウンド数（手動指定時、nullの場合は自動計算）。
 int? get maxRounds;/// 予定参加者数（自動計算用）。
 int? get expectedPlayers;
/// Create a copy of CreateTournamentRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateTournamentRequestCopyWith<CreateTournamentRequest> get copyWith => _$CreateTournamentRequestCopyWithImpl<CreateTournamentRequest>(this as CreateTournamentRequest, _$identity);

  /// Serializes this CreateTournamentRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTournamentRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.venue, venue) || other.venue == venue)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.drawPoints, drawPoints) || other.drawPoints == drawPoints)&&(identical(other.maxRounds, maxRounds) || other.maxRounds == maxRounds)&&(identical(other.expectedPlayers, expectedPlayers) || other.expectedPlayers == expectedPlayers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,venue,startDate,endDate,drawPoints,maxRounds,expectedPlayers);

@override
String toString() {
  return 'CreateTournamentRequest(title: $title, description: $description, venue: $venue, startDate: $startDate, endDate: $endDate, drawPoints: $drawPoints, maxRounds: $maxRounds, expectedPlayers: $expectedPlayers)';
}


}

/// @nodoc
abstract mixin class $CreateTournamentRequestCopyWith<$Res>  {
  factory $CreateTournamentRequestCopyWith(CreateTournamentRequest value, $Res Function(CreateTournamentRequest) _then) = _$CreateTournamentRequestCopyWithImpl;
@useResult
$Res call({
 String title, String description, String venue, String startDate, String endDate, int drawPoints, int? maxRounds, int? expectedPlayers
});




}
/// @nodoc
class _$CreateTournamentRequestCopyWithImpl<$Res>
    implements $CreateTournamentRequestCopyWith<$Res> {
  _$CreateTournamentRequestCopyWithImpl(this._self, this._then);

  final CreateTournamentRequest _self;
  final $Res Function(CreateTournamentRequest) _then;

/// Create a copy of CreateTournamentRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? description = null,Object? venue = null,Object? startDate = null,Object? endDate = null,Object? drawPoints = null,Object? maxRounds = freezed,Object? expectedPlayers = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,venue: null == venue ? _self.venue : venue // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String,drawPoints: null == drawPoints ? _self.drawPoints : drawPoints // ignore: cast_nullable_to_non_nullable
as int,maxRounds: freezed == maxRounds ? _self.maxRounds : maxRounds // ignore: cast_nullable_to_non_nullable
as int?,expectedPlayers: freezed == expectedPlayers ? _self.expectedPlayers : expectedPlayers // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _CreateTournamentRequest implements CreateTournamentRequest {
  const _CreateTournamentRequest({required this.title, required this.description, required this.venue, required this.startDate, required this.endDate, this.drawPoints = 0, this.maxRounds, this.expectedPlayers});
  factory _CreateTournamentRequest.fromJson(Map<String, dynamic> json) => _$CreateTournamentRequestFromJson(json);

/// 大会タイトル。
@override final  String title;
/// 大会の説明。
@override final  String description;
/// 開催会場。
@override final  String venue;
/// 大会開始日時（ISO 8601 形式）。
@override final  String startDate;
/// 大会終了日時（ISO 8601 形式）。
@override final  String endDate;
/// 引き分け得点（0点 or 1点）。
@override@JsonKey() final  int drawPoints;
/// ラウンド数（手動指定時、nullの場合は自動計算）。
@override final  int? maxRounds;
/// 予定参加者数（自動計算用）。
@override final  int? expectedPlayers;

/// Create a copy of CreateTournamentRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateTournamentRequestCopyWith<_CreateTournamentRequest> get copyWith => __$CreateTournamentRequestCopyWithImpl<_CreateTournamentRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateTournamentRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateTournamentRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.venue, venue) || other.venue == venue)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.drawPoints, drawPoints) || other.drawPoints == drawPoints)&&(identical(other.maxRounds, maxRounds) || other.maxRounds == maxRounds)&&(identical(other.expectedPlayers, expectedPlayers) || other.expectedPlayers == expectedPlayers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,venue,startDate,endDate,drawPoints,maxRounds,expectedPlayers);

@override
String toString() {
  return 'CreateTournamentRequest(title: $title, description: $description, venue: $venue, startDate: $startDate, endDate: $endDate, drawPoints: $drawPoints, maxRounds: $maxRounds, expectedPlayers: $expectedPlayers)';
}


}

/// @nodoc
abstract mixin class _$CreateTournamentRequestCopyWith<$Res> implements $CreateTournamentRequestCopyWith<$Res> {
  factory _$CreateTournamentRequestCopyWith(_CreateTournamentRequest value, $Res Function(_CreateTournamentRequest) _then) = __$CreateTournamentRequestCopyWithImpl;
@override @useResult
$Res call({
 String title, String description, String venue, String startDate, String endDate, int drawPoints, int? maxRounds, int? expectedPlayers
});




}
/// @nodoc
class __$CreateTournamentRequestCopyWithImpl<$Res>
    implements _$CreateTournamentRequestCopyWith<$Res> {
  __$CreateTournamentRequestCopyWithImpl(this._self, this._then);

  final _CreateTournamentRequest _self;
  final $Res Function(_CreateTournamentRequest) _then;

/// Create a copy of CreateTournamentRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = null,Object? venue = null,Object? startDate = null,Object? endDate = null,Object? drawPoints = null,Object? maxRounds = freezed,Object? expectedPlayers = freezed,}) {
  return _then(_CreateTournamentRequest(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,venue: null == venue ? _self.venue : venue // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String,drawPoints: null == drawPoints ? _self.drawPoints : drawPoints // ignore: cast_nullable_to_non_nullable
as int,maxRounds: freezed == maxRounds ? _self.maxRounds : maxRounds // ignore: cast_nullable_to_non_nullable
as int?,expectedPlayers: freezed == expectedPlayers ? _self.expectedPlayers : expectedPlayers // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
