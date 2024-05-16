import 'package:sails_io/sails_io.dart';
import 'package:securities_app/application.dart';
import 'package:securities_app/config/app_config.dart';
import 'package:securities_app/global/socket/model/socket_data.dart';
import 'package:securities_app/global/socket/model/socket_stock_data.dart';
import 'package:securities_app/global/socket/socket_data_center.dart';
import 'package:securities_app/global/utils/app_log_util.dart';
import 'package:socket_io_client/socket_io_client.dart' as io_client;


class SocketConnect {
  static final SocketConnect _singleton = SocketConnect._internal();

  factory SocketConnect() => _singleton;

  SocketConnect._internal();

  final connectKey = 'connect';
  final connectTimeout = 'connect_timeout';
  final errorKey = 'error';
  final reconnectingKey = 'reconnecting';
  final disconnectKey = 'disconnect';
  final reconnectFailedKey = 'reconnect_failed';
  final reconnectErrorKey = 'reconnect_error';
  final reconnectAttemptKey = 'reconnect_attempt';
  final listenStockKey = '';

  io_client.Socket? _socket;

  bool _forceDisconnect = false;

  final Set<String> _stockSubscribedList = {};
  final Set<String> _exchangeSubscribedList = {};

  void connect() {
    _forceDisconnect = false;
    _initSocket();
    _connect();
  }

  /// still keep old listener when disconnect socket
  void disconnect() {
    _forceDisconnect = true;

    if (_socket != null) {
      _socket?.dispose();
      _socket = null;
    }
  }

  /// only call this method when logout
  /// remove all listener and disconnect
  void destroy() {
    _stockSubscribedList.clear();
    _exchangeSubscribedList.clear();

    disconnect();
  }

  void subscribeStock(String symbol) {
    _emitSubscribeStock(symbol, true);
  }

  void unsubscribeStock(String symbol) {
    _emitSubscribeStock(symbol, false);
  }

  void subscribeExchange(String id) {
    // _emitSubscribeExchange(id, true);
  }

  void unsubscribeExchange(String symbol) {
    // _emitSubscribeExchange(symbol, false);
  }

  void _initSocket() {
    String url = sl.get<AppConfig>().config.socketUrl;
    SailsIOClient sailsIOClient = SailsIOClient(
      io_client.io(
        '$url?__sails_io_sdk_version=1.2.1',
        io_client.OptionBuilder()
            .enableForceNew()
            .enableForceNewConnection()
            .enableAutoConnect()
            .enableReconnection()
            .setTransports(['websocket'])
            .build(),
      ),
    );
    _socket = sailsIOClient.socket;
  }

  void _connect() {
    _socket?.on(connectKey, (_) {
      dlog('❤️❤️❤️❤️❤️ SOCKET CONNECTED');
      _reSubscribeAfterSocketReconnect();
    });

    _socket?.onReconnect((data) {
      dlog('❤️❤️❤️❤️❤️ SOCKET RECONNECT');
    });

    _socket?.on(connectTimeout, (_) {
      dlog('❤️❤️❤️❤️❤️ SOCKET CONNECT TIMEOUT');

      reconnect();
    });

    _socket?.on(errorKey, (_) {
      dlog('❤️❤️❤️❤️❤️ SOCKET ERROR');
    });

    _socket?.on(reconnectingKey, (_) {
      dlog('❤️❤️❤️❤️❤️ SOCKET RECONNECTING');
    });

    _socket?.on(disconnectKey, (_) {
      dlog('⚠️⚠️⚠️⚠️⚠️ SOCKET DISCONNECT');

      reconnect();
    });

    _socket?.on(reconnectFailedKey, (_) {
      dlog('⚠️⚠️⚠️⚠️⚠️ SOCKET RECONNECT FAILED');
    });

    _socket?.on(reconnectErrorKey, (_) {
      dlog('⚠️⚠️⚠️⚠️⚠️ SOCKET RECONNECT ERROR');
    });

    _socket?.on(reconnectAttemptKey, (_) {
      dlog('✨✨✨✨✨️ SOCKET RECONNECT ATTEMPT');
    });

    _socket?.on(listenStockKey, (data) {
      _transformStockData(data);
    });


  }

  void reconnect() {
    if (!_forceDisconnect) connect();
  }

  void _reSubscribeAfterSocketReconnect() {
    //Re-subscribe stocks
    if (_stockSubscribedList.isNotEmpty) {
      for (int i = 0; i < _stockSubscribedList.length; i++) {
        _emitSubscribeStock(_stockSubscribedList.elementAt(i), true);
      }
    }

    //Re-subscribe exchange
    // if (_exchangeSubscribedList.isNotEmpty) {
    //   for (int i = 0; i < _exchangeSubscribedList.length; i++) {
    //     _emitSubscribeExchange(_exchangeSubscribedList.elementAt(i), true);
    //   }
    // }
  }

  void _emitSubscribeStock(String symbol, bool isSubscribe) {
    if (_socket != null && _socket!.connected) {
      isSubscribe
          ? _stockSubscribedList.add(symbol)
          : _stockSubscribedList.remove(symbol);
      // _socket!.emitWithAck(
      //     'get',
      //     {
      //       {
      //         'method': 'get',
      //         'url': '/client/subscribe',
      //         'data': {
      //           'op': isSubscribe ? 'subscribe' : 'unsubscribe',
      //           'args': ["i:$symbol"]
      //         }
      //       }
      //     },
      //     ack: (data) {});
    }
  }

  // void _emitSubscribeExchange(String symbol, bool isSubscribe) {
  //   if (_socket != null && _socket!.connected) {
  //     isSubscribe
  //         ? _exchangeSubscribedList.add(symbol)
  //         : _exchangeSubscribedList.remove(symbol);
  //     _socket!.emitWithAck(
  //         'get',
  //         {
  //           {
  //             'method': 'get',
  //             'url': '/client/subscribe',
  //             'data': {
  //               'op': isSubscribe ? 'subscribe' : 'unsubscribe',
  //               'args': ["idx:$symbol"]
  //             }
  //           }
  //         },
  //         ack: (data) {});
  //   }
  // }

  void _transformStockData(dynamic data) {
    if (data != null) {
      final socketData = SocketData.fromJson(data);
      SocketStockData stockData = SocketStockData.fromJson(socketData.data[0]);
      sl.get<SocketDataCenter>().updateStockSocketData(stockData);
    }
  }

}
