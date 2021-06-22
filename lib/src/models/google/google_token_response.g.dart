// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_token_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoogleTokenResponse _$GoogleTokenResponseFromJson(Map<String, dynamic> json) {
  return GoogleTokenResponse(
    accessToken: json['access_token'] as String?,
    expiresIn: json['expires_in'] as int?,
    tokenType: json['token_type'] as String?,
  );
}

Map<String, dynamic> _$GoogleTokenResponseToJson(
        GoogleTokenResponse instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'expires_in': instance.expiresIn,
      'token_type': instance.tokenType,
    };
