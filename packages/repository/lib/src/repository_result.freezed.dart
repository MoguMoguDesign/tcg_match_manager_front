// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'repository_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RepositoryResult<T> {

/// [T] 型の DTO クラス用フィールド。
///
/// reason が [FailureRepositoryResultReason.failureStatus] の場合、
/// 成功時と同じ DTO クラスを格納する必要がある。
 T? get data;



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RepositoryResult<T>&&const DeepCollectionEquality().equals(other.data, data));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'RepositoryResult<$T>(data: $data)';
}


}

/// @nodoc
class $RepositoryResultCopyWith<T,$Res>  {
$RepositoryResultCopyWith(RepositoryResult<T> _, $Res Function(RepositoryResult<T>) __);
}


/// @nodoc


class SuccessRepositoryResult<T> implements RepositoryResult<T> {
  const SuccessRepositoryResult(this.data);
  

@override final  T data;

/// Create a copy of RepositoryResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SuccessRepositoryResultCopyWith<T, SuccessRepositoryResult<T>> get copyWith => _$SuccessRepositoryResultCopyWithImpl<T, SuccessRepositoryResult<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SuccessRepositoryResult<T>&&const DeepCollectionEquality().equals(other.data, data));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'RepositoryResult<$T>.success(data: $data)';
}


}

/// @nodoc
abstract mixin class $SuccessRepositoryResultCopyWith<T,$Res> implements $RepositoryResultCopyWith<T, $Res> {
  factory $SuccessRepositoryResultCopyWith(SuccessRepositoryResult<T> value, $Res Function(SuccessRepositoryResult<T>) _then) = _$SuccessRepositoryResultCopyWithImpl;
@useResult
$Res call({
 T data
});




}
/// @nodoc
class _$SuccessRepositoryResultCopyWithImpl<T,$Res>
    implements $SuccessRepositoryResultCopyWith<T, $Res> {
  _$SuccessRepositoryResultCopyWithImpl(this._self, this._then);

  final SuccessRepositoryResult<T> _self;
  final $Res Function(SuccessRepositoryResult<T>) _then;

/// Create a copy of RepositoryResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = freezed,}) {
  return _then(SuccessRepositoryResult<T>(
freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T,
  ));
}


}

/// @nodoc


class FailureRepositoryResult<T> implements RepositoryResult<T> {
  const FailureRepositoryResult(this.e, {required this.reason, this.data, this.statusCode}): assert(reason != FailureRepositoryResultReason.failureStatus || data != null, 'data must not be null when reason is failureStatus');
  

/// 例外オブジェクト。
///
/// reason が [FailureRepositoryResultReason.failureStatus] の場合、
/// [data] へ変換する前の [JsonMap] を格納しておく。
 final  Object e;
/// 失敗の理由を表す列挙型。
 final  FailureRepositoryResultReason reason;
/// [T] 型の DTO クラス用フィールド。
///
/// reason が [FailureRepositoryResultReason.failureStatus] の場合、
/// 成功時と同じ DTO クラスを格納する必要がある。
@override final  T? data;
/// HTTP レスポンスのステータスコード。
///
/// reason が [FailureRepositoryResultReason.badResponse] の場合には NN となる。
 final  int? statusCode;

/// Create a copy of RepositoryResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FailureRepositoryResultCopyWith<T, FailureRepositoryResult<T>> get copyWith => _$FailureRepositoryResultCopyWithImpl<T, FailureRepositoryResult<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FailureRepositoryResult<T>&&const DeepCollectionEquality().equals(other.e, e)&&(identical(other.reason, reason) || other.reason == reason)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(e),reason,const DeepCollectionEquality().hash(data),statusCode);

@override
String toString() {
  return 'RepositoryResult<$T>.failure(e: $e, reason: $reason, data: $data, statusCode: $statusCode)';
}


}

/// @nodoc
abstract mixin class $FailureRepositoryResultCopyWith<T,$Res> implements $RepositoryResultCopyWith<T, $Res> {
  factory $FailureRepositoryResultCopyWith(FailureRepositoryResult<T> value, $Res Function(FailureRepositoryResult<T>) _then) = _$FailureRepositoryResultCopyWithImpl;
@useResult
$Res call({
 Object e, FailureRepositoryResultReason reason, T? data, int? statusCode
});




}
/// @nodoc
class _$FailureRepositoryResultCopyWithImpl<T,$Res>
    implements $FailureRepositoryResultCopyWith<T, $Res> {
  _$FailureRepositoryResultCopyWithImpl(this._self, this._then);

  final FailureRepositoryResult<T> _self;
  final $Res Function(FailureRepositoryResult<T>) _then;

/// Create a copy of RepositoryResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? e = null,Object? reason = null,Object? data = freezed,Object? statusCode = freezed,}) {
  return _then(FailureRepositoryResult<T>(
null == e ? _self.e : e ,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as FailureRepositoryResultReason,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T?,statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
