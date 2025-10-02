import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../../utils/log_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ConnectionManagerController extends GetxController {
  var isConnected = false.obs;

  final Connectivity _connectivity = Connectivity();

  late StreamSubscription _streamSubscription;

  @override
  void onInit() {
    super.onInit();

    getConnectivityType();
    _streamSubscription = _connectivity.onConnectivityChanged.listen(
      _updateState,
      onError: (error) {
        Log.e("The Connectivity Listener Error", error.toString());
      },
    );
  }

  Future<void> getConnectivityType() async {
    List<ConnectivityResult> connectivityResult = [];
    try {
      connectivityResult = await _connectivity.checkConnectivity();
      _updateState(connectivityResult);
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void _updateState(List<ConnectivityResult> result) async {
    switch (result.first) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        isConnected.value = true;
        break;
      case ConnectivityResult.none:
      default:
        isConnected.value = false;
        break;
    }
  }

  @override
  void onClose() {
    _streamSubscription.cancel();
  }
}
