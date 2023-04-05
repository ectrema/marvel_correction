import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

@singleton
class ConnectivityServive {
  final bool _isConnected;

  ConnectivityServive._(this._isConnected);

  bool get isConnected => _isConnected;

  @factoryMethod
  static Future<ConnectivityServive> inject() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    return ConnectivityServive._(
        connectivityResult == ConnectivityResult.wifi ||
            connectivityResult == ConnectivityResult.mobile);
  }
}
