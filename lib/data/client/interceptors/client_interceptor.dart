import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:marvel_app/data/client/dio_client.dart';
import 'package:marvel_app/infrastructure/services/auth_service.dart';

@singleton
class AuthorizationBearerInterceptor {
  final AuthService authService;
  final DioClient dioClient;

  AuthorizationBearerInterceptor(this.dioClient, this.authService) {
    _registerInterceptor();
  }

  Future<void> _onRequestInterceptor(RequestOptions options,
      RequestInterceptorHandler requestInterceptorHandler) async {
    options.headers.addAll(
      <String, String>{
        'Accept': 'application/json',
      },
    );

    final Map<String, String> headers = <String, String>{
      'ts': '1',
      'apikey': authService.publicKey,
      'hash': md5
          .convert(
              utf8.encode('1${authService.privateKey}${authService.publicKey}'))
          .toString(),
    };
    options.queryParameters.addAll(headers);

    requestInterceptorHandler.next(options);
  }

  void _registerInterceptor() {
    dioClient.interceptors.add(
      QueuedInterceptorsWrapper(
          onRequest: _onRequestInterceptor,
          onResponse:
              (Response<dynamic> response, ResponseInterceptorHandler handler) {
            return handler.next(response); // continue
          },
          onError: (DioError e, ErrorInterceptorHandler handler) {
            return handler.next(e);
          }),
    );
  }
}
