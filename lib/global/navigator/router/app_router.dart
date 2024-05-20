import 'package:flutter/material.dart';
import 'router_module.dart';

class AppRouter extends RouterModule {
  AppRouter();
  static const String splash = '/splash';
  static const String signIn = '/signIn';
  static const String main = '/main';

  Route<dynamic>? generateRoute({
    required RouteSettings settings,
  }) {
    final routesMap = <String, MaterialPageRoute>{};
    routesMap.addAll(getRoutes(settings));
    return routesMap[settings.name];
  }


  @override
  Map<String, MaterialPageRoute> getRoutes(RouteSettings settings) {
    return {
      // AppRouter.splash: MaterialPageRoute(builder: (context) => const SplashPage(), settings: settings),
      // AppRouter.signIn: MaterialPageRoute(builder: (context) => const SigninPage(), settings: settings),
      // AppRouter.main: MaterialPageRoute(builder: (context) => const MainPage(), settings: settings),
    };
  }
}
