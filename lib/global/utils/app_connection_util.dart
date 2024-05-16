import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:uuid/uuid.dart';

class AppConnectionUtils {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>>? _streamConnection;
  List<ConnectivityResult> _type = [];
  final Map<String, Function(AppConnectionUtils)?> _onStatusChange = {};
  bool _isActive = false;
  late final String _callbackId;

  AppConnectionUtils._(Function(AppConnectionUtils)? onStatusChange) {
    _callbackId = const Uuid().v4();
    _onStatusChange[_callbackId] = onStatusChange;
    _initialize();
  }

  factory AppConnectionUtils.noCallback() {
    return AppConnectionUtils._(null);
  }

  factory AppConnectionUtils.instance(
    Function(AppConnectionUtils)? onStatusChange,
  ) {
    return AppConnectionUtils._(onStatusChange);
  }

  List<ConnectivityResult> get type => _type;

  bool get isActive => _isActive;

  void dispose() {
    _streamConnection?.cancel();
    _streamConnection = null;
  }

  Future<void> _initialize() async {
    if (_streamConnection != null) {
      return;
    }

    _streamConnection = _connectivity.onConnectivityChanged.listen(
      (result) {
        _type = result;
        _isActive = !_type.contains(ConnectivityResult.none);
        _onStatusChange.forEach((id, callback) {
          callback?.call(this);
        });
      },
    );
  }
}
