import 'package:flutter/material.dart';
import 'package:piechat/src/features/presentation/screens/authentication/sign_in/sign_in_screen.dart';
import 'package:piechat/src/features/presentation/screens/authentication/sign_up/sign_up_screen.dart';
import '../../features/presentation/screens/splash/splash_screen.dart';
import 'route_names.dart';

class RouteConfigs {
  static MaterialPageRoute generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
      case RoutesName.signIn:
        return MaterialPageRoute(
          builder: (context) => const SignInScreen(),
        );
      case RoutesName.signUp:
        return MaterialPageRoute(
          builder: (context) => const SignUpScreen(),
        );


      default:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
    }
  }
}
