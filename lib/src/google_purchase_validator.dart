import 'dart:convert';
import 'dart:io';

import 'package:corsac_jwt/corsac_jwt.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import 'models/google/google_token_response.dart';
import 'models/google/google_validation.dart';
import 'models/google/google_validation_response.dart';
import 'models/google/google_validation_result.dart';

export 'models/google/google_validation.dart';
export 'models/google/google_validation_result.dart';

class _Token {
  final String token;
  final DateTime expiration;

  _Token(this.token, this.expiration);

  bool get expired {
    return DateTime.now().isAfter(expiration);
  }
}

class GooglePurchaseValidator {
  static const String _GET_TOKEN = 'https://accounts.google.com/o/oauth2/token';
  static const String _SCOPE =
      'https://www.googleapis.com/auth/androidpublisher';

  final String _packageName;
  final String _clientEmail;
  final String _privateKey;

  GooglePurchaseValidator._(
      this._packageName, this._clientEmail, this._privateKey);

  _Token token;

  static Future<GooglePurchaseValidator> create(String keyAssetPath,
      [String packageName]) async {
    final keyTxt = await rootBundle.loadString(keyAssetPath);
    final key = jsonDecode(keyTxt);
    final clientEmail = key['client_email'];
    final privateKey = key['private_key'];
    if (packageName == null) {
      final packageInfo = await PackageInfo.fromPlatform();
      packageName = packageInfo.packageName;
    }
    return GooglePurchaseValidator._(packageName, clientEmail, privateKey);
  }

  String _getProductUrl(String productId, String purchaseToken,
      String accessToken, bool subscription) {
    return 'https://www.googleapis.com/androidpublisher/v3/applications/$_packageName/purchases/${subscription ? 'subscriptions' : 'products'}/$productId/tokens/$purchaseToken?access_token=$accessToken';
  }

  String get _jwtToken {
    final now = DateTime.now();
    var builder = JWTBuilder();
    builder
      ..issuer = _clientEmail
      ..audience = _GET_TOKEN
      ..expiresAt = now.add(Duration(hours: 1))
      ..issuedAt = now
      ..setClaim('scope', _SCOPE);
    var signer = JWTRsaSha256Signer(privateKey: _privateKey);
    var signedToken = builder.getSignedToken(signer);
    var stringToken = signedToken.toString();
    return stringToken;
  }

  Future<_Token> _requestToken() async {
    final result = await http.post(_GET_TOKEN,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded'
        },
        body:
            'grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=' +
                _jwtToken);
    final json = jsonDecode(result.body);
    final tokenResponse = GoogleTokenResponse.fromJson(json);
    final expiration = (tokenResponse.expiresIn ?? 0) * 1000;
    final token = _Token(
        tokenResponse.accessToken,
        DateTime.fromMillisecondsSinceEpoch(
            DateTime.now().millisecondsSinceEpoch + expiration));
    return token;
  }

  Future<GoogleValidationResult> getPurchaseInfo(
      String productId, String purchaseToken) async {
    if (token?.expired ?? true) {
      token = await _requestToken();
    }
    final url = _getProductUrl(productId, purchaseToken, token.token, false);
    final result = await http.get(url);
    final json = jsonDecode(result.body);
    final validation = GoogleValidationResponse.fromJson(json);
    GooglePurchaseInfo receipt;
    if (validation.error == null) {
      receipt = GooglePurchaseInfo.fromResponse(validation);
    }
    return GoogleValidationResult(
        receipt, validation.error?.code ?? 0, validation.error?.message);
  }
}
