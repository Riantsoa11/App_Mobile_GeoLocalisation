import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  Future<bool> checkIsOnline() async {
    final results = await Connectivity().checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }

  Stream<bool> get onChange => Connectivity().onConnectivityChanged.map(
    (results) => !results.contains(ConnectivityResult.none),
  );
}
