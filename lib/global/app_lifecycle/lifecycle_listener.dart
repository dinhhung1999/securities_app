import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

handleAppLifecycleState() {
  AppLifecycleState _lastLifecyleState;
  SystemChannels.lifecycle.setMessageHandler((msg) async {

    log('SystemChannels: $msg');

    switch (msg) {
      case "AppLifecycleState.paused":
        _lastLifecyleState = AppLifecycleState.paused;
        break;
      case "AppLifecycleState.inactive":
        _lastLifecyleState = AppLifecycleState.inactive;
        break;
      case "AppLifecycleState.resumed":
        _lastLifecyleState = AppLifecycleState.resumed;
        LifecycleListener().eventResumedStreamController.add(true);
        break;
      case "AppLifecycleState.detached":
        _lastLifecyleState = AppLifecycleState.detached;
        break;
      default:
    }
  });
}

class LifecycleListener{
  static final LifecycleListener _singleton=LifecycleListener._internal();
  factory LifecycleListener(){
    return _singleton;
  }
  LifecycleListener._internal();


  final StreamController<bool> eventResumedStreamController = StreamController<bool>.broadcast();
  Stream<bool> get streamResumed => eventResumedStreamController.stream;

  final StreamController<bool> eventPausedStreamController = StreamController<bool>.broadcast();
  Stream<bool> get streamPaused => eventPausedStreamController.stream;

  final StreamController<bool> eventInactiveStreamController = StreamController<bool>.broadcast();
  Stream<bool> get streamInactive => eventInactiveStreamController.stream;

  final StreamController<bool> eventDetachedStreamController = StreamController<bool>.broadcast();
  Stream<bool> get streamDetached => eventDetachedStreamController.stream;
}
