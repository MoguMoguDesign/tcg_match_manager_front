// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'http_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HttpResponse {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HttpResponse);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HttpResponse()';
}


}

/// @nodoc
class $HttpResponseCopyWith<$Res>  {
$HttpResponseCopyWith(HttpResponse _, $Res Function(HttpResponse) __);
}


/// @nodoc


class SuccessHttpResponse implements HttpResponse {
  const SuccessHttpResponse({required final  JsonMap jsonData, required final  Map<String, List<String>> headers}): _jsonData = jsonData,_headers = headers;
  

/// HTTP のレスポンスボディ。
///
/// 実際のレスポンスボディは String 型だが、扱いやすいように JsonMap 型にデコードした形で格納する。
 final  JsonMap _jsonData;
/// HTTP のレスポンスボディ。
///
/// 実際のレスポンスボディは String 型だが、扱いやすいように JsonMap 型にデコードした形で格納する。
 JsonMap get jsonData {
  if (_jsonData is EqualUnmodifiableMapView) return _jsonData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_jsonData);
}

/// HTTP のレスポンスヘッダ。
 final  Map<String, List<String>> _headers;
/// HTTP のレスポンスヘッダ。
 Map<String, List<String>> get headers {
  if (_headers is EqualUnmodifiableMapView) return _headers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_headers);
}


/// Create a copy of HttpResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SuccessHttpResponseCopyWith<SuccessHttpResponse> get copyWith => _$SuccessHttpResponseCopyWithImpl<SuccessHttpResponse>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SuccessHttpResponse&&const DeepCollectionEquality().equals(other._jsonData, _jsonData)&&const DeepCollectionEquality().equals(other._headers, _headers));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_jsonData),const DeepCollectionEquality().hash(_headers));

@override
String toString() {
  return 'HttpResponse.success(jsonData: $jsonData, headers: $headers)';
}


}

/// @nodoc
abstract mixin class $SuccessHttpResponseCopyWith<$Res> implements $HttpResponseCopyWith<$Res> {
  factory $SuccessHttpResponseCopyWith(SuccessHttpResponse value, $Res Function(SuccessHttpResponse) _then) = _$SuccessHttpResponseCopyWithImpl;
@useResult
$Res call({
 JsonMap jsonData, Map<String, List<String>> headers
});




}
/// @nodoc
class _$SuccessHttpResponseCopyWithImpl<$Res>
    implements $SuccessHttpResponseCopyWith<$Res> {
  _$SuccessHttpResponseCopyWithImpl(this._self, this._then);

  final SuccessHttpResponse _self;
  final $Res Function(SuccessHttpResponse) _then;

/// Create a copy of HttpResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? jsonData = null,Object? headers = null,}) {
  return _then(SuccessHttpResponse(
jsonData: null == jsonData ? _self._jsonData : jsonData // ignore: cast_nullable_to_non_nullable
as JsonMap,headers: null == headers ? _self._headers : headers // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>,
  ));
}


}

/// @nodoc


class FailureHttpResponse implements HttpResponse {
  const FailureHttpResponse({required this.e, required this.status, this.statusCode});
  

/// HTTP リクエスト時に発生した例外オブジェクト。
 final  Object e;
///  HTTP エラーの種別。
 final  ErrorStatus status;
/// HTTP レスポンスのステータスコード。
///
/// status が [ErrorStatus.badResponse] の場合には NN となる。
 final  int? statusCode;

/// Create a copy of HttpResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FailureHttpResponseCopyWith<FailureHttpResponse> get copyWith => _$FailureHttpResponseCopyWithImpl<FailureHttpResponse>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FailureHttpResponse&&const DeepCollectionEquality().equals(other.e, e)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(e),status,statusCode);

@override
String toString() {
  return 'HttpResponse.failure(e: $e, status: $status, statusCode: $statusCode)';
}


}

/// @nodoc
abstract mixin class $FailureHttpResponseCopyWith<$Res> implements $HttpResponseCopyWith<$Res> {
  factory $FailureHttpResponseCopyWith(FailureHttpResponse value, $Res Function(FailureHttpResponse) _then) = _$FailureHttpResponseCopyWithImpl;
@useResult
$Res call({
 Object e, ErrorStatus status, int? statusCode
});




}
/// @nodoc
class _$FailureHttpResponseCopyWithImpl<$Res>
    implements $FailureHttpResponseCopyWith<$Res> {
  _$FailureHttpResponseCopyWithImpl(this._self, this._then);

  final FailureHttpResponse _self;
  final $Res Function(FailureHttpResponse) _then;

/// Create a copy of HttpResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? e = null,Object? status = null,Object? statusCode = freezed,}) {
  return _then(FailureHttpResponse(
e: null == e ? _self.e : e ,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ErrorStatus,statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
