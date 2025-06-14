import 'package:flutter/material.dart';
import '../../features/presentation/screens/authentication/login/login_screen.dart';
import '../../features/presentation/screens/splash/splash_screen.dart';
import 'route_names.dart';

class RouteConfigs {
  static MaterialPageRoute generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
      case RoutesName.login:
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
    }
  }
}
