import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:kurumi/config/env.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Oauth {
  Future<String?> auth() async {
    var dio = Dio();
    final clientId = ENV().clientId;
    final redirectUri = ENV().redirectUri;
    final clientSecret = ENV().clientSecret;
    var authUrl =
        'https://anilist.co/api/v2/oauth/authorize?client_id=$clientId&redirect_uri=$redirectUri&response_type=code';
    print(authUrl);
    final result = await FlutterWebAuth2.authenticate(
      url: authUrl,
      callbackUrlScheme: 'kurumi',
    );

    final code = Uri.parse(result).queryParameters['code'];
    // Use this code to get an access token
    final response = await dio.post(
      'https://anilist.co/api/v2/oauth/token',
      data: {
        'grant_type': 'authorization_code',
        'client_id': clientId,
        'client_secret': clientSecret,
        'redirect_uri': redirectUri,
        'code': code
      },
    );
    final String? accessToken = response.data['access_token'];
    if (kDebugMode) {
      print(response.data);
      print(accessToken);
    }
    if (accessToken != null) {
      FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();
      await flutterSecureStorage.write(
          key: 'AniListAccessToken', value: accessToken);
      final pref = await SharedPreferences.getInstance();
      pref.setBool('isLoggedIn', true);
    }
    return accessToken;
  }
}
