import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityServices {
  Future<bool> getNetworkStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
}
