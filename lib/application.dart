import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:get_it/get_it.dart';
import 'package:securities_app/global/navigator/navigation/navigation.dart';
import 'package:securities_app/global/navigator/router/app_router.dart';
import 'package:securities_app/global/navigator/router/router_module.dart';
import 'package:securities_app/global/navigator/router/router_observer.dart';
import 'package:securities_app/global/socket/socket_connect.dart';
import 'package:securities_app/global/utils/app_connection_util.dart';
import 'package:securities_app/global/app_lifecycle/app_lifecycle_listener.dart';

final RouteObserver<PageRoute<dynamic>> routeObserver =
    RouteObserver<PageRoute<dynamic>>();

final sl = GetIt.instance;

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  ApplicationState createState() => ApplicationState();
}

class ApplicationState extends AppLifeCycleListener<Application>
    with WidgetsBindingObserver {
  ThemeData? _currentTheme;
  bool hasConnect = false;

  late final AppConnectionUtils connectionUtils;
  List<ConnectivityResult> connectionResult = [];
  bool firstNetworkChange = true;

  @override
  void initState() {
    super.initState();
    // set up firebase while before use in _initApp()
    _initConnectivity();
    // Session.instance().addListener(_sessionChanged);
  }

  @override
  void dispose() {
    connectionUtils.dispose();
    SocketConnect().disconnect();
    super.dispose();
  }

  @override
  void onPauseApp() {
    SocketConnect().disconnect();
  }

  @override
  void onResumeApp() {
    SocketConnect().connect();
  }

  _initConnectivity() async {
    List<ConnectivityResult>? result;
    try {
      result = await Connectivity().checkConnectivity();
    } on PlatformException catch (e) {
      debugPrint('PlatformException: ${e.toString()}');
    }

    if (!mounted) {
      return Future.value(null);
    }
    connectionResult = result ?? [];
    connectionUtils = AppConnectionUtils.instance(
      (connection) {
        if (firstNetworkChange) {
          firstNetworkChange = false;
        } else if (connectionResult != connection.type) {
          if (connectionUtils.isActive) {
            SocketConnect().connect();
          } else {
            SocketConnect().disconnect();
          }

          connectionResult = connection.type;
        }
      },
    );
  }

  // void _sessionChanged() {
  //   if (Session.instance().state == SessionState.expired) {
  //     //
  //     Session.instance().reInit(shouldNotify: false);
  //     // Do redirect
  //     SchedulerBinding.instance.addPostFrameCallback(
  //           (timeStamp) {
  //         final Navigation navigation = GetIt.I<Navigation>();
  //
  //         navigation.popToFirst();
  //         navigation.showLogin();
  //       },
  //     );
  //
  //     // Clean account place order
  //     GetIt.I<BlocAuthentication>().authController.add(Authen.LOGOUT);
  //   }
  // }

  // void _listentMqttConnect() {
  //   if (MqttState.instance().state == MqttConnectionState.connected) {
  //     String masterAccount = Session.instance().masterAccount ?? "";
  //
  //     if (masterAccount != null && masterAccount.isNotEmpty) {
  //       MqttHandler.shared.subscribeOrderListStatus(masterAccount);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigation.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: _currentTheme,
      navigatorObservers: [sl.get<AppRouteObserver>()],
      initialRoute: AppRouter.splash,
      onGenerateRoute: (settings) =>
          generateRoute(routes: AppRouter(), settings: settings),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }

  Route<dynamic>? generateRoute({
    required RouterModule routes,
    required RouteSettings settings,
  }) {
    final routesMap = <String, MaterialPageRoute>{};
    routesMap.addAll(routes.getRoutes(settings));
    return routesMap[settings.name];
  }
}
