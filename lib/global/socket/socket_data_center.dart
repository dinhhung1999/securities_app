import 'package:rxdart/rxdart.dart';
import 'package:securities_app/global/socket/model/socket_stock_data.dart';
import 'package:securities_app/global/socket/socket_connect.dart';
import 'package:uuid/uuid.dart';

import 'socket_subscriber.dart';

/// Private class
class _SocketNotifier<T> {
  final PublishSubject<T> observer;

  _SocketNotifier(this.observer);
}

/// Private class
class _SocketObservationPair<T> {
  final String uniqueId;
  final PublishSubject<T> _dataSource;
  final Function() _dispose;
  late SocketSubscriber<T> subscriber;
  late _SocketNotifier<T> notifier;

  _SocketObservationPair(
      {required this.uniqueId,
      required PublishSubject<T> dataSource,
      required Function() onDispose})
      : _dataSource = dataSource,
        _dispose = onDispose {
    notifier = _SocketNotifier(_dataSource);
    subscriber = SocketSubscriber(_dataSource.stream, _onSubscriberDispose);
  }

  void _onSubscriberDispose() {
    _dispose();
  }
}

class SocketDataCenter {
  //hold all observation for stock data change
  final Map<String, List<_SocketObservationPair<SocketStockData>>>
      _stockListenerPool =
      <String, List<_SocketObservationPair<SocketStockData>>>{};



  SocketSubscriber<SocketStockData> addObserverForStockChanged(String symbol) =>
      _addObserverForChanged<SocketStockData>(symbol, _stockListenerPool);



  SocketSubscriber<T> _addObserverForChanged<T>(
      String code, Map<String, List<_SocketObservationPair<T>>> pool) {
    final String uniqueId = const Uuid().v1();
    final _SocketObservationPair<T> pair = _SocketObservationPair<T>(
      uniqueId: uniqueId,
      dataSource: PublishSubject<T>(),
      onDispose: () => _removeObservationFromPool(code, uniqueId, pool),
    );

    List<_SocketObservationPair<T>>? listPairsForCode = pool[code];

    if (listPairsForCode == null || listPairsForCode.isEmpty) {
      //subscribe data changed with socket
      _subscribe(code, pool);

      /// Create new list for the code
      /// then let the [_listenerPool] hold reference to this connection
      listPairsForCode = <_SocketObservationPair<T>>[];
      listPairsForCode.add(pair);
      pool[code] = listPairsForCode;
    } else {
      /// Just add new new listener cause the list is reference type
      /// it don't need to re-assigned to the [_listenerPool]
      listPairsForCode.add(pair);
    }

    return pair.subscriber;
  }

  void _removeObservationFromPool(String code, String uniqueId,
      Map<String, List<_SocketObservationPair>> pool) {
    List<_SocketObservationPair>? listPairsForCode = pool[code];
    if (listPairsForCode != null) {
      listPairsForCode.removeWhere(
          (_SocketObservationPair element) => element.uniqueId == uniqueId);
      //If there is no subscribe left => unsubscribe with socketio
      if (listPairsForCode.isEmpty) {
        _unsubscribe(code, pool);
      }
    }
  }

  void _subscribe(String code, Map<String, List<_SocketObservationPair>> pool) {
    if (pool is Map<String, List<_SocketObservationPair<SocketStockData>>>) {
      SocketConnect().subscribeStock(code);
    }
    // else if (pool
    //     is Map<String, List<_SocketObservationPair<SocketMarketData>>>) {
    //   SocketConnect().subscribeExchange(code);
    // }
  }

  void _unsubscribe(
      String code, Map<String, List<_SocketObservationPair>> pool) {
    if (pool is Map<String, List<_SocketObservationPair<SocketStockData>>>) {
      SocketConnect().unsubscribeStock(code);
    }
    // else if (pool
    //     is Map<String, List<_SocketObservationPair<SocketMarketData>>>) {
    //   SocketConnect().unsubscribeExchange(code);
    // }
  }

  void updateStockSocketData(SocketStockData data) {
    final String symbol = data.sym;
    if (!_stockListenerPool.containsKey(symbol)) {
      return;
    }
    final List<_SocketNotifier<SocketStockData>>?
        listNotifierForSpecificSecCode = _stockListenerPool[symbol]
            ?.map((_SocketObservationPair<SocketStockData> e) => e.notifier)
            .toList();
    if (listNotifierForSpecificSecCode != null) {
      for (int j = 0; j < listNotifierForSpecificSecCode.length; j++) {
        listNotifierForSpecificSecCode[j].observer.add(data);
      }
    }
  }

  // void updateMarketData(SocketMarketData data) {
  //   final String marketCode = data.marketCd;
  //   if (!_marketListenerPool.containsKey(marketCode)) {
  //     return;
  //   }
  //   final List<_SocketNotifier<SocketMarketData>>? listeners =
  //       _marketListenerPool[marketCode]!
  //           .map((_SocketObservationPair<SocketMarketData> e) => e.notifier)
  //           .toList();
  //   if (listeners != null) {
  //     for (int j = 0; j < listeners.length; j++) {
  //       listeners[j].observer.add(data);
  //     }
  //   }
  // }


  void destroy() {
    _stockListenerPool.clear();
  }
}
