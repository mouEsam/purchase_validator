import 'package:json_annotation/json_annotation.dart';

part 'google_token_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class GoogleTokenResponse {
  GoogleTokenResponse({
    this.accessToken,
    this.expiresIn,
    this.tokenType,
  });

  final String accessToken;
  final int expiresIn;
  final String tokenType;

  factory GoogleTokenResponse.fromJson(Map<String, dynamic> json) => _$GoogleTokenResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GoogleTokenResponseToJson(this);
}