import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:injectable/injectable.dart';

@singleton
class DioClient extends DioForNative {
  static const String dioBaseUrl = r'https://gateway.marvel.com/v1/public';

  ///
  /// Get default [BaseOptions]
  ///
  static BaseOptions baseOptions(String baseUrl) => BaseOptions()
    ..followRedirects = true
    ..baseUrl = baseUrl
    ..connectTimeout = const Duration(seconds: 30)
    ..maxRedirects = 5
    ..contentType = Headers.formUrlEncodedContentType;

  ///
  /// Constructor
  ///
  DioClient._(String baseUrl) : super(baseOptions(baseUrl));

  @factoryMethod
  static DioClient inject() {
    return DioClient._(dioBaseUrl);
  }
}
