// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'match.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Match {

/// マッチ ID。
 String get id;/// 卓番号。
 int get tableNumber;/// 公開されているかどうか。
 bool get published;/// プレイヤー1。
 MatchPlayer get player1;/// プレイヤー2。
 MatchPlayer get player2;/// BYE マッチかどうか。
 bool get isByeMatch;/// 結果（未確定の場合は null）。
 MatchResultDetail? get result;/// 自分のマッチかどうか。
 bool get isMine;/// 自分の側（player1 または player2、自分のマッチでない場合は null）。
 String? get meSide;
/// Create a copy of Match
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MatchCopyWith<Match> get copyWith => _$MatchCopyWithImpl<Match>(this as Match, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Match&&(identical(other.id, id) || other.id == id)&&(identical(other.tableNumber, tableNumber) || other.tableNumber == tableNumber)&&(identical(other.published, published) || other.published == published)&&(identical(other.player1, player1) || other.player1 == player1)&&(identical(other.player2, player2) || other.player2 == player2)&&(identical(other.isByeMatch, isByeMatch) || other.isByeMatch == isByeMatch)&&(identical(other.result, result) || other.result == result)&&(identical(other.isMine, isMine) || other.isMine == isMine)&&(identical(other.meSide, meSide) || other.meSide == meSide));
}


@override
int get hashCode => Object.hash(runtimeType,id,tableNumber,published,player1,player2,isByeMatch,result,isMine,meSide);

@override
String toString() {
  return 'Match(id: $id, tableNumber: $tableNumber, published: $published, player1: $player1, player2: $player2, isByeMatch: $isByeMatch, result: $result, isMine: $isMine, meSide: $meSide)';
}


}

/// @nodoc
abstract mixin class $MatchCopyWith<$Res>  {
  factory $MatchCopyWith(Match value, $Res Function(Match) _then) = _$MatchCopyWithImpl;
@useResult
$Res call({
 String id, int tableNumber, bool published, MatchPlayer player1, MatchPlayer player2, bool isByeMatch, MatchResultDetail? result, bool isMine, String? meSide
});


$MatchPlayerCopyWith<$Res> get player1;$MatchPlayerCopyWith<$Res> get player2;$MatchResultDetailCopyWith<$Res>? get result;

}
/// @nodoc
class _$MatchCopyWithImpl<$Res>
    implements $MatchCopyWith<$Res> {
  _$MatchCopyWithImpl(this._self, this._then);

  final Match _self;
  final $Res Function(Match) _then;

/// Create a copy of Match
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tableNumber = null,Object? published = null,Object? player1 = null,Object? player2 = null,Object? isByeMatch = null,Object? result = freezed,Object? isMine = null,Object? meSide = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tableNumber: null == tableNumber ? _self.tableNumber : tableNumber // ignore: cast_nullable_to_non_nullable
as int,published: null == published ? _self.published : published // ignore: cast_nullable_to_non_nullable
as bool,player1: null == player1 ? _self.player1 : player1 // ignore: cast_nullable_to_non_nullable
as MatchPlayer,player2: null == player2 ? _self.player2 : player2 // ignore: cast_nullable_to_non_nullable
as MatchPlayer,isByeMatch: null == isByeMatch ? _self.isByeMatch : isByeMatch // ignore: cast_nullable_to_non_nullable
as bool,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as MatchResultDetail?,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,meSide: freezed == meSide ? _self.meSide : meSide // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of Match
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MatchPlayerCopyWith<$Res> get player1 {
  
  return $MatchPlayerCopyWith<$Res>(_self.player1, (value) {
    return _then(_self.copyWith(player1: value));
  });
}/// Create a copy of Match
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MatchPlayerCopyWith<$Res> get player2 {
  
  return $MatchPlayerCopyWith<$Res>(_self.player2, (value) {
    return _then(_self.copyWith(player2: value));
  });
}/// Create a copy of Match
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MatchResultDetailCopyWith<$Res>? get result {
    if (_self.result == null) {
    return null;
  }

  return $MatchResultDetailCopyWith<$Res>(_self.result!, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}


/// @nodoc


class _Match extends Match {
  const _Match({required this.id, required this.tableNumber, required this.published, required this.player1, required this.player2, required this.isByeMatch, this.result, required this.isMine, this.meSide}): super._();
  

/// マッチ ID。
@override final  String id;
/// 卓番号。
@override final  int tableNumber;
/// 公開されているかどうか。
@override final  bool published;
/// プレイヤー1。
@override final  MatchPlayer player1;
/// プレイヤー2。
@override final  MatchPlayer player2;
/// BYE マッチかどうか。
@override final  bool isByeMatch;
/// 結果（未確定の場合は null）。
@override final  MatchResultDetail? result;
/// 自分のマッチかどうか。
@override final  bool isMine;
/// 自分の側（player1 または player2、自分のマッチでない場合は null）。
@override final  String? meSide;

/// Create a copy of Match
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MatchCopyWith<_Match> get copyWith => __$MatchCopyWithImpl<_Match>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Match&&(identical(other.id, id) || other.id == id)&&(identical(other.tableNumber, tableNumber) || other.tableNumber == tableNumber)&&(identical(other.published, published) || other.published == published)&&(identical(other.player1, player1) || other.player1 == player1)&&(identical(other.player2, player2) || other.player2 == player2)&&(identical(other.isByeMatch, isByeMatch) || other.isByeMatch == isByeMatch)&&(identical(other.result, result) || other.result == result)&&(identical(other.isMine, isMine) || other.isMine == isMine)&&(identical(other.meSide, meSide) || other.meSide == meSide));
}


@override
int get hashCode => Object.hash(runtimeType,id,tableNumber,published,player1,player2,isByeMatch,result,isMine,meSide);

@override
String toString() {
  return 'Match(id: $id, tableNumber: $tableNumber, published: $published, player1: $player1, player2: $player2, isByeMatch: $isByeMatch, result: $result, isMine: $isMine, meSide: $meSide)';
}


}

/// @nodoc
abstract mixin class _$MatchCopyWith<$Res> implements $MatchCopyWith<$Res> {
  factory _$MatchCopyWith(_Match value, $Res Function(_Match) _then) = __$MatchCopyWithImpl;
@override @useResult
$Res call({
 String id, int tableNumber, bool published, MatchPlayer player1, MatchPlayer player2, bool isByeMatch, MatchResultDetail? result, bool isMine, String? meSide
});


@override $MatchPlayerCopyWith<$Res> get player1;@override $MatchPlayerCopyWith<$Res> get player2;@override $MatchResultDetailCopyWith<$Res>? get result;

}
/// @nodoc
class __$MatchCopyWithImpl<$Res>
    implements _$MatchCopyWith<$Res> {
  __$MatchCopyWithImpl(this._self, this._then);

  final _Match _self;
  final $Res Function(_Match) _then;

/// Create a copy of Match
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tableNumber = null,Object? published = null,Object? player1 = null,Object? player2 = null,Object? isByeMatch = null,Object? result = freezed,Object? isMine = null,Object? meSide = freezed,}) {
  return _then(_Match(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tableNumber: null == tableNumber ? _self.tableNumber : tableNumber // ignore: cast_nullable_to_non_nullable
as int,published: null == published ? _self.published : published // ignore: cast_nullable_to_non_nullable
as bool,player1: null == player1 ? _self.player1 : player1 // ignore: cast_nullable_to_non_nullable
as MatchPlayer,player2: null == player2 ? _self.player2 : player2 // ignore: cast_nullable_to_non_nullable
as MatchPlayer,isByeMatch: null == isByeMatch ? _self.isByeMatch : isByeMatch // ignore: cast_nullable_to_non_nullable
as bool,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as MatchResultDetail?,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,meSide: freezed == meSide ? _self.meSide : meSide // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of Match
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MatchPlayerCopyWith<$Res> get player1 {
  
  return $MatchPlayerCopyWith<$Res>(_self.player1, (value) {
    return _then(_self.copyWith(player1: value));
  });
}/// Create a copy of Match
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MatchPlayerCopyWith<$Res> get player2 {
  
  return $MatchPlayerCopyWith<$Res>(_self.player2, (value) {
    return _then(_self.copyWith(player2: value));
  });
}/// Create a copy of Match
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MatchResultDetailCopyWith<$Res>? get result {
    if (_self.result == null) {
    return null;
  }

  return $MatchResultDetailCopyWith<$Res>(_self.result!, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}

/// @nodoc
mixin _$MatchPlayer {

/// プレイヤー ID。
 String get id;/// プレイヤー名。
 String get name;/// マッチングポイント（累計勝点）。
 int get matchingPoints;
/// Create a copy of MatchPlayer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MatchPlayerCopyWith<MatchPlayer> get copyWith => _$MatchPlayerCopyWithImpl<MatchPlayer>(this as MatchPlayer, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MatchPlayer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.matchingPoints, matchingPoints) || other.matchingPoints == matchingPoints));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,matchingPoints);

@override
String toString() {
  return 'MatchPlayer(id: $id, name: $name, matchingPoints: $matchingPoints)';
}


}

/// @nodoc
abstract mixin class $MatchPlayerCopyWith<$Res>  {
  factory $MatchPlayerCopyWith(MatchPlayer value, $Res Function(MatchPlayer) _then) = _$MatchPlayerCopyWithImpl;
@useResult
$Res call({
 String id, String name, int matchingPoints
});




}
/// @nodoc
class _$MatchPlayerCopyWithImpl<$Res>
    implements $MatchPlayerCopyWith<$Res> {
  _$MatchPlayerCopyWithImpl(this._self, this._then);

  final MatchPlayer _self;
  final $Res Function(MatchPlayer) _then;

/// Create a copy of MatchPlayer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? matchingPoints = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,matchingPoints: null == matchingPoints ? _self.matchingPoints : matchingPoints // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc


class _MatchPlayer extends MatchPlayer {
  const _MatchPlayer({required this.id, required this.name, required this.matchingPoints}): super._();
  

/// プレイヤー ID。
@override final  String id;
/// プレイヤー名。
@override final  String name;
/// マッチングポイント（累計勝点）。
@override final  int matchingPoints;

/// Create a copy of MatchPlayer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MatchPlayerCopyWith<_MatchPlayer> get copyWith => __$MatchPlayerCopyWithImpl<_MatchPlayer>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MatchPlayer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.matchingPoints, matchingPoints) || other.matchingPoints == matchingPoints));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,matchingPoints);

@override
String toString() {
  return 'MatchPlayer(id: $id, name: $name, matchingPoints: $matchingPoints)';
}


}

/// @nodoc
abstract mixin class _$MatchPlayerCopyWith<$Res> implements $MatchPlayerCopyWith<$Res> {
  factory _$MatchPlayerCopyWith(_MatchPlayer value, $Res Function(_MatchPlayer) _then) = __$MatchPlayerCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int matchingPoints
});




}
/// @nodoc
class __$MatchPlayerCopyWithImpl<$Res>
    implements _$MatchPlayerCopyWith<$Res> {
  __$MatchPlayerCopyWithImpl(this._self, this._then);

  final _MatchPlayer _self;
  final $Res Function(_MatchPlayer) _then;

/// Create a copy of MatchPlayer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? matchingPoints = null,}) {
  return _then(_MatchPlayer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,matchingPoints: null == matchingPoints ? _self.matchingPoints : matchingPoints // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$MatchResultDetail {

/// 結果タイプ。
 String get type;/// 勝者のプレイヤー ID。
 String? get winnerId;/// 送信日時。
 String? get submittedAt;/// 送信したプレイヤー ID。
 String? get submittedBy;/// 送信者のユーザー ID。
 String? get submitterUserId;
/// Create a copy of MatchResultDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MatchResultDetailCopyWith<MatchResultDetail> get copyWith => _$MatchResultDetailCopyWithImpl<MatchResultDetail>(this as MatchResultDetail, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MatchResultDetail&&(identical(other.type, type) || other.type == type)&&(identical(other.winnerId, winnerId) || other.winnerId == winnerId)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.submittedBy, submittedBy) || other.submittedBy == submittedBy)&&(identical(other.submitterUserId, submitterUserId) || other.submitterUserId == submitterUserId));
}


@override
int get hashCode => Object.hash(runtimeType,type,winnerId,submittedAt,submittedBy,submitterUserId);

@override
String toString() {
  return 'MatchResultDetail(type: $type, winnerId: $winnerId, submittedAt: $submittedAt, submittedBy: $submittedBy, submitterUserId: $submitterUserId)';
}


}

/// @nodoc
abstract mixin class $MatchResultDetailCopyWith<$Res>  {
  factory $MatchResultDetailCopyWith(MatchResultDetail value, $Res Function(MatchResultDetail) _then) = _$MatchResultDetailCopyWithImpl;
@useResult
$Res call({
 String type, String? winnerId, String? submittedAt, String? submittedBy, String? submitterUserId
});




}
/// @nodoc
class _$MatchResultDetailCopyWithImpl<$Res>
    implements $MatchResultDetailCopyWith<$Res> {
  _$MatchResultDetailCopyWithImpl(this._self, this._then);

  final MatchResultDetail _self;
  final $Res Function(MatchResultDetail) _then;

/// Create a copy of MatchResultDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? winnerId = freezed,Object? submittedAt = freezed,Object? submittedBy = freezed,Object? submitterUserId = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,winnerId: freezed == winnerId ? _self.winnerId : winnerId // ignore: cast_nullable_to_non_nullable
as String?,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as String?,submittedBy: freezed == submittedBy ? _self.submittedBy : submittedBy // ignore: cast_nullable_to_non_nullable
as String?,submitterUserId: freezed == submitterUserId ? _self.submitterUserId : submitterUserId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc


class _MatchResultDetail extends MatchResultDetail {
  const _MatchResultDetail({required this.type, this.winnerId, this.submittedAt, this.submittedBy, this.submitterUserId}): super._();
  

/// 結果タイプ。
@override final  String type;
/// 勝者のプレイヤー ID。
@override final  String? winnerId;
/// 送信日時。
@override final  String? submittedAt;
/// 送信したプレイヤー ID。
@override final  String? submittedBy;
/// 送信者のユーザー ID。
@override final  String? submitterUserId;

/// Create a copy of MatchResultDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MatchResultDetailCopyWith<_MatchResultDetail> get copyWith => __$MatchResultDetailCopyWithImpl<_MatchResultDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MatchResultDetail&&(identical(other.type, type) || other.type == type)&&(identical(other.winnerId, winnerId) || other.winnerId == winnerId)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.submittedBy, submittedBy) || other.submittedBy == submittedBy)&&(identical(other.submitterUserId, submitterUserId) || other.submitterUserId == submitterUserId));
}


@override
int get hashCode => Object.hash(runtimeType,type,winnerId,submittedAt,submittedBy,submitterUserId);

@override
String toString() {
  return 'MatchResultDetail(type: $type, winnerId: $winnerId, submittedAt: $submittedAt, submittedBy: $submittedBy, submitterUserId: $submitterUserId)';
}


}

/// @nodoc
abstract mixin class _$MatchResultDetailCopyWith<$Res> implements $MatchResultDetailCopyWith<$Res> {
  factory _$MatchResultDetailCopyWith(_MatchResultDetail value, $Res Function(_MatchResultDetail) _then) = __$MatchResultDetailCopyWithImpl;
@override @useResult
$Res call({
 String type, String? winnerId, String? submittedAt, String? submittedBy, String? submitterUserId
});




}
/// @nodoc
class __$MatchResultDetailCopyWithImpl<$Res>
    implements _$MatchResultDetailCopyWith<$Res> {
  __$MatchResultDetailCopyWithImpl(this._self, this._then);

  final _MatchResultDetail _self;
  final $Res Function(_MatchResultDetail) _then;

/// Create a copy of MatchResultDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? winnerId = freezed,Object? submittedAt = freezed,Object? submittedBy = freezed,Object? submitterUserId = freezed,}) {
  return _then(_MatchResultDetail(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,winnerId: freezed == winnerId ? _self.winnerId : winnerId // ignore: cast_nullable_to_non_nullable
as String?,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as String?,submittedBy: freezed == submittedBy ? _self.submittedBy : submittedBy // ignore: cast_nullable_to_non_nullable
as String?,submitterUserId: freezed == submitterUserId ? _self.submitterUserId : submitterUserId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
