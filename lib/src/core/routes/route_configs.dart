import 'package:flutter/material.dart';
import 'package:piechat/src/features/presentation/screens/authentication/sign_in/sign_in_screen.dart';
import 'package:piechat/src/features/presentation/screens/authentication/sign_up/sign_up_screen.dart';
import 'package:piechat/src/features/presentation/screens/splash/splash_screen.dart';
import 'package:piechat/src/features/presentation/screens/user/chat/chat_message_screen.dart';
import 'package:piechat/src/features/presentation/screens/user/home/home_screen.dart';
import 'route_names.dart';

class RouteConfigs {
  static MaterialPageRoute generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case RoutesName.signIn:
        return MaterialPageRoute(
          builder: (_) => const SignInScreen(),
        );
      case RoutesName.signUp:
        return MaterialPageRoute(
          builder: (_) => const SignUpScreen(),
        );
      case RoutesName.home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
      case RoutesName.chatMessage:
        final args = settings.arguments as Map<String, dynamic>;
        final receiverId = args['receiverId'];
        final receiverName = args['receiverName'];
        return MaterialPageRoute(
          builder: (_) => ChatMessageScreen(receiverId: receiverId, receiverName: receiverName),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
    }
  }
}
