import 'package:injectable/injectable.dart';

@singleton
class AuthService {
  final String _privateKey;
  final String _publicKey;
  final String _apiKey;

  String get privateKey => _privateKey;
  String get publicKey => _publicKey;
  String get apiKey => _apiKey;

  AuthService._(this._privateKey, this._publicKey, this._apiKey);

  @factoryMethod
  static AuthService inject() {
    const String privateKey = String.fromEnvironment('PRIVATE_KEY');
    const String publicKey = String.fromEnvironment('PUBLIC_KEY');
    const String apiKey = String.fromEnvironment('API_KEY');
    return AuthService._(privateKey, publicKey, apiKey);
  }
}
