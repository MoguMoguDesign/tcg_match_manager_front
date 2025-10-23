// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tournament_info_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TournamentInfoResponse {

/// 大会 ID。
 String get id;/// 大会名。
 String get name;/// 大会ステータス。
 String get status;/// スケジュール設定。
 ScheduleInfo get schedule;/// 現在のラウンド番号。
 int get currentRound;
/// Create a copy of TournamentInfoResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TournamentInfoResponseCopyWith<TournamentInfoResponse> get copyWith => _$TournamentInfoResponseCopyWithImpl<TournamentInfoResponse>(this as TournamentInfoResponse, _$identity);

  /// Serializes this TournamentInfoResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TournamentInfoResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.schedule, schedule) || other.schedule == schedule)&&(identical(other.currentRound, currentRound) || other.currentRound == currentRound));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,status,schedule,currentRound);

@override
String toString() {
  return 'TournamentInfoResponse(id: $id, name: $name, status: $status, schedule: $schedule, currentRound: $currentRound)';
}


}

/// @nodoc
abstract mixin class $TournamentInfoResponseCopyWith<$Res>  {
  factory $TournamentInfoResponseCopyWith(TournamentInfoResponse value, $Res Function(TournamentInfoResponse) _then) = _$TournamentInfoResponseCopyWithImpl;
@useResult
$Res call({
 String id, String name, String status, ScheduleInfo schedule, int currentRound
});


$ScheduleInfoCopyWith<$Res> get schedule;

}
/// @nodoc
class _$TournamentInfoResponseCopyWithImpl<$Res>
    implements $TournamentInfoResponseCopyWith<$Res> {
  _$TournamentInfoResponseCopyWithImpl(this._self, this._then);

  final TournamentInfoResponse _self;
  final $Res Function(TournamentInfoResponse) _then;

/// Create a copy of TournamentInfoResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? status = null,Object? schedule = null,Object? currentRound = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,schedule: null == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as ScheduleInfo,currentRound: null == currentRound ? _self.currentRound : currentRound // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of TournamentInfoResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScheduleInfoCopyWith<$Res> get schedule {
  
  return $ScheduleInfoCopyWith<$Res>(_self.schedule, (value) {
    return _then(_self.copyWith(schedule: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _TournamentInfoResponse implements TournamentInfoResponse {
  const _TournamentInfoResponse({required this.id, required this.name, required this.status, required this.schedule, required this.currentRound});
  factory _TournamentInfoResponse.fromJson(Map<String, dynamic> json) => _$TournamentInfoResponseFromJson(json);

/// 大会 ID。
@override final  String id;
/// 大会名。
@override final  String name;
/// 大会ステータス。
@override final  String status;
/// スケジュール設定。
@override final  ScheduleInfo schedule;
/// 現在のラウンド番号。
@override final  int currentRound;

/// Create a copy of TournamentInfoResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TournamentInfoResponseCopyWith<_TournamentInfoResponse> get copyWith => __$TournamentInfoResponseCopyWithImpl<_TournamentInfoResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TournamentInfoResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TournamentInfoResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.schedule, schedule) || other.schedule == schedule)&&(identical(other.currentRound, currentRound) || other.currentRound == currentRound));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,status,schedule,currentRound);

@override
String toString() {
  return 'TournamentInfoResponse(id: $id, name: $name, status: $status, schedule: $schedule, currentRound: $currentRound)';
}


}

/// @nodoc
abstract mixin class _$TournamentInfoResponseCopyWith<$Res> implements $TournamentInfoResponseCopyWith<$Res> {
  factory _$TournamentInfoResponseCopyWith(_TournamentInfoResponse value, $Res Function(_TournamentInfoResponse) _then) = __$TournamentInfoResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String status, ScheduleInfo schedule, int currentRound
});


@override $ScheduleInfoCopyWith<$Res> get schedule;

}
/// @nodoc
class __$TournamentInfoResponseCopyWithImpl<$Res>
    implements _$TournamentInfoResponseCopyWith<$Res> {
  __$TournamentInfoResponseCopyWithImpl(this._self, this._then);

  final _TournamentInfoResponse _self;
  final $Res Function(_TournamentInfoResponse) _then;

/// Create a copy of TournamentInfoResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? status = null,Object? schedule = null,Object? currentRound = null,}) {
  return _then(_TournamentInfoResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,schedule: null == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as ScheduleInfo,currentRound: null == currentRound ? _self.currentRound : currentRound // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of TournamentInfoResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScheduleInfoCopyWith<$Res> get schedule {
  
  return $ScheduleInfoCopyWith<$Res>(_self.schedule, (value) {
    return _then(_self.copyWith(schedule: value));
  });
}
}


/// @nodoc
mixin _$ScheduleInfo {

/// スケジュールモード（FIXED または UNTIL_CHAMPION）。
 String get mode;/// 総ラウンド数（FIXED モードの場合）。
 int? get totalRounds;/// 最大ラウンド数（UNTIL_CHAMPION モードの場合）。
 int? get maxRounds;
/// Create a copy of ScheduleInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleInfoCopyWith<ScheduleInfo> get copyWith => _$ScheduleInfoCopyWithImpl<ScheduleInfo>(this as ScheduleInfo, _$identity);

  /// Serializes this ScheduleInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleInfo&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.totalRounds, totalRounds) || other.totalRounds == totalRounds)&&(identical(other.maxRounds, maxRounds) || other.maxRounds == maxRounds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mode,totalRounds,maxRounds);

@override
String toString() {
  return 'ScheduleInfo(mode: $mode, totalRounds: $totalRounds, maxRounds: $maxRounds)';
}


}

/// @nodoc
abstract mixin class $ScheduleInfoCopyWith<$Res>  {
  factory $ScheduleInfoCopyWith(ScheduleInfo value, $Res Function(ScheduleInfo) _then) = _$ScheduleInfoCopyWithImpl;
@useResult
$Res call({
 String mode, int? totalRounds, int? maxRounds
});




}
/// @nodoc
class _$ScheduleInfoCopyWithImpl<$Res>
    implements $ScheduleInfoCopyWith<$Res> {
  _$ScheduleInfoCopyWithImpl(this._self, this._then);

  final ScheduleInfo _self;
  final $Res Function(ScheduleInfo) _then;

/// Create a copy of ScheduleInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? totalRounds = freezed,Object? maxRounds = freezed,}) {
  return _then(_self.copyWith(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,totalRounds: freezed == totalRounds ? _self.totalRounds : totalRounds // ignore: cast_nullable_to_non_nullable
as int?,maxRounds: freezed == maxRounds ? _self.maxRounds : maxRounds // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _ScheduleInfo implements ScheduleInfo {
  const _ScheduleInfo({required this.mode, this.totalRounds, this.maxRounds});
  factory _ScheduleInfo.fromJson(Map<String, dynamic> json) => _$ScheduleInfoFromJson(json);

/// スケジュールモード（FIXED または UNTIL_CHAMPION）。
@override final  String mode;
/// 総ラウンド数（FIXED モードの場合）。
@override final  int? totalRounds;
/// 最大ラウンド数（UNTIL_CHAMPION モードの場合）。
@override final  int? maxRounds;

/// Create a copy of ScheduleInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleInfoCopyWith<_ScheduleInfo> get copyWith => __$ScheduleInfoCopyWithImpl<_ScheduleInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleInfo&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.totalRounds, totalRounds) || other.totalRounds == totalRounds)&&(identical(other.maxRounds, maxRounds) || other.maxRounds == maxRounds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mode,totalRounds,maxRounds);

@override
String toString() {
  return 'ScheduleInfo(mode: $mode, totalRounds: $totalRounds, maxRounds: $maxRounds)';
}


}

/// @nodoc
abstract mixin class _$ScheduleInfoCopyWith<$Res> implements $ScheduleInfoCopyWith<$Res> {
  factory _$ScheduleInfoCopyWith(_ScheduleInfo value, $Res Function(_ScheduleInfo) _then) = __$ScheduleInfoCopyWithImpl;
@override @useResult
$Res call({
 String mode, int? totalRounds, int? maxRounds
});




}
/// @nodoc
class __$ScheduleInfoCopyWithImpl<$Res>
    implements _$ScheduleInfoCopyWith<$Res> {
  __$ScheduleInfoCopyWithImpl(this._self, this._then);

  final _ScheduleInfo _self;
  final $Res Function(_ScheduleInfo) _then;

/// Create a copy of ScheduleInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? totalRounds = freezed,Object? maxRounds = freezed,}) {
  return _then(_ScheduleInfo(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,totalRounds: freezed == totalRounds ? _self.totalRounds : totalRounds // ignore: cast_nullable_to_non_nullable
as int?,maxRounds: freezed == maxRounds ? _self.maxRounds : maxRounds // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
