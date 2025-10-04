// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'standing_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StandingResponse {

/// 計算日時。
 String get calculatedAt;/// 順位表。
 List<Ranking> get rankings;
/// Create a copy of StandingResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StandingResponseCopyWith<StandingResponse> get copyWith => _$StandingResponseCopyWithImpl<StandingResponse>(this as StandingResponse, _$identity);

  /// Serializes this StandingResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StandingResponse&&(identical(other.calculatedAt, calculatedAt) || other.calculatedAt == calculatedAt)&&const DeepCollectionEquality().equals(other.rankings, rankings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,calculatedAt,const DeepCollectionEquality().hash(rankings));

@override
String toString() {
  return 'StandingResponse(calculatedAt: $calculatedAt, rankings: $rankings)';
}


}

/// @nodoc
abstract mixin class $StandingResponseCopyWith<$Res>  {
  factory $StandingResponseCopyWith(StandingResponse value, $Res Function(StandingResponse) _then) = _$StandingResponseCopyWithImpl;
@useResult
$Res call({
 String calculatedAt, List<Ranking> rankings
});




}
/// @nodoc
class _$StandingResponseCopyWithImpl<$Res>
    implements $StandingResponseCopyWith<$Res> {
  _$StandingResponseCopyWithImpl(this._self, this._then);

  final StandingResponse _self;
  final $Res Function(StandingResponse) _then;

/// Create a copy of StandingResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? calculatedAt = null,Object? rankings = null,}) {
  return _then(_self.copyWith(
calculatedAt: null == calculatedAt ? _self.calculatedAt : calculatedAt // ignore: cast_nullable_to_non_nullable
as String,rankings: null == rankings ? _self.rankings : rankings // ignore: cast_nullable_to_non_nullable
as List<Ranking>,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _StandingResponse implements StandingResponse {
  const _StandingResponse({required this.calculatedAt, required final  List<Ranking> rankings}): _rankings = rankings;
  factory _StandingResponse.fromJson(Map<String, dynamic> json) => _$StandingResponseFromJson(json);

/// 計算日時。
@override final  String calculatedAt;
/// 順位表。
 final  List<Ranking> _rankings;
/// 順位表。
@override List<Ranking> get rankings {
  if (_rankings is EqualUnmodifiableListView) return _rankings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rankings);
}


/// Create a copy of StandingResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StandingResponseCopyWith<_StandingResponse> get copyWith => __$StandingResponseCopyWithImpl<_StandingResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StandingResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StandingResponse&&(identical(other.calculatedAt, calculatedAt) || other.calculatedAt == calculatedAt)&&const DeepCollectionEquality().equals(other._rankings, _rankings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,calculatedAt,const DeepCollectionEquality().hash(_rankings));

@override
String toString() {
  return 'StandingResponse(calculatedAt: $calculatedAt, rankings: $rankings)';
}


}

/// @nodoc
abstract mixin class _$StandingResponseCopyWith<$Res> implements $StandingResponseCopyWith<$Res> {
  factory _$StandingResponseCopyWith(_StandingResponse value, $Res Function(_StandingResponse) _then) = __$StandingResponseCopyWithImpl;
@override @useResult
$Res call({
 String calculatedAt, List<Ranking> rankings
});




}
/// @nodoc
class __$StandingResponseCopyWithImpl<$Res>
    implements _$StandingResponseCopyWith<$Res> {
  __$StandingResponseCopyWithImpl(this._self, this._then);

  final _StandingResponse _self;
  final $Res Function(_StandingResponse) _then;

/// Create a copy of StandingResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? calculatedAt = null,Object? rankings = null,}) {
  return _then(_StandingResponse(
calculatedAt: null == calculatedAt ? _self.calculatedAt : calculatedAt // ignore: cast_nullable_to_non_nullable
as String,rankings: null == rankings ? _self._rankings : rankings // ignore: cast_nullable_to_non_nullable
as List<Ranking>,
  ));
}


}


/// @nodoc
mixin _$Ranking {

/// 順位。
 int get rank;/// プレイヤー名。
 String get playerName;/// 累計勝ち点。
 int get matchPoints;/// OMWP（Opponent Match Win Percentage）。
 double get omwPercentage;
/// Create a copy of Ranking
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RankingCopyWith<Ranking> get copyWith => _$RankingCopyWithImpl<Ranking>(this as Ranking, _$identity);

  /// Serializes this Ranking to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Ranking&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.playerName, playerName) || other.playerName == playerName)&&(identical(other.matchPoints, matchPoints) || other.matchPoints == matchPoints)&&(identical(other.omwPercentage, omwPercentage) || other.omwPercentage == omwPercentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rank,playerName,matchPoints,omwPercentage);

@override
String toString() {
  return 'Ranking(rank: $rank, playerName: $playerName, matchPoints: $matchPoints, omwPercentage: $omwPercentage)';
}


}

/// @nodoc
abstract mixin class $RankingCopyWith<$Res>  {
  factory $RankingCopyWith(Ranking value, $Res Function(Ranking) _then) = _$RankingCopyWithImpl;
@useResult
$Res call({
 int rank, String playerName, int matchPoints, double omwPercentage
});




}
/// @nodoc
class _$RankingCopyWithImpl<$Res>
    implements $RankingCopyWith<$Res> {
  _$RankingCopyWithImpl(this._self, this._then);

  final Ranking _self;
  final $Res Function(Ranking) _then;

/// Create a copy of Ranking
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rank = null,Object? playerName = null,Object? matchPoints = null,Object? omwPercentage = null,}) {
  return _then(_self.copyWith(
rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,matchPoints: null == matchPoints ? _self.matchPoints : matchPoints // ignore: cast_nullable_to_non_nullable
as int,omwPercentage: null == omwPercentage ? _self.omwPercentage : omwPercentage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Ranking implements Ranking {
  const _Ranking({required this.rank, required this.playerName, required this.matchPoints, required this.omwPercentage});
  factory _Ranking.fromJson(Map<String, dynamic> json) => _$RankingFromJson(json);

/// 順位。
@override final  int rank;
/// プレイヤー名。
@override final  String playerName;
/// 累計勝ち点。
@override final  int matchPoints;
/// OMWP（Opponent Match Win Percentage）。
@override final  double omwPercentage;

/// Create a copy of Ranking
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RankingCopyWith<_Ranking> get copyWith => __$RankingCopyWithImpl<_Ranking>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RankingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Ranking&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.playerName, playerName) || other.playerName == playerName)&&(identical(other.matchPoints, matchPoints) || other.matchPoints == matchPoints)&&(identical(other.omwPercentage, omwPercentage) || other.omwPercentage == omwPercentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rank,playerName,matchPoints,omwPercentage);

@override
String toString() {
  return 'Ranking(rank: $rank, playerName: $playerName, matchPoints: $matchPoints, omwPercentage: $omwPercentage)';
}


}

/// @nodoc
abstract mixin class _$RankingCopyWith<$Res> implements $RankingCopyWith<$Res> {
  factory _$RankingCopyWith(_Ranking value, $Res Function(_Ranking) _then) = __$RankingCopyWithImpl;
@override @useResult
$Res call({
 int rank, String playerName, int matchPoints, double omwPercentage
});




}
/// @nodoc
class __$RankingCopyWithImpl<$Res>
    implements _$RankingCopyWith<$Res> {
  __$RankingCopyWithImpl(this._self, this._then);

  final _Ranking _self;
  final $Res Function(_Ranking) _then;

/// Create a copy of Ranking
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rank = null,Object? playerName = null,Object? matchPoints = null,Object? omwPercentage = null,}) {
  return _then(_Ranking(
rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,matchPoints: null == matchPoints ? _self.matchPoints : matchPoints // ignore: cast_nullable_to_non_nullable
as int,omwPercentage: null == omwPercentage ? _self.omwPercentage : omwPercentage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
