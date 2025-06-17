import 'package:flutter/material.dart';
import 'package:piechat/src/features/data/repositories/chat_repository.dart';
import 'package:piechat/src/features/data/services/service_locator.dart';
import 'package:piechat/src/features/logic/cubits/auth/auth_cubit.dart';
import 'package:piechat/src/features/logic/cubits/auth/auth_state.dart';
import 'package:piechat/src/features/logic/observer/app_life_cycle_observer.dart';
import '../routes/route_configs.dart';
import '../routes/route_names.dart';
import '../routes/router.dart';
import '../utils/constants/strings.dart';
import 'app_theme.dart';

class PieChat extends StatefulWidget {
  const PieChat({super.key});

  @override
  State<PieChat> createState() => _PieChatState();
}

class _PieChatState extends State<PieChat> {
  late AppLifeCycleObserver _appLifeCycleObserver;
  @override
  void initState() {
    super.initState();
    getIt<AuthCubit>().stream.listen((state) {
      if (state.status == AuthStatus.authenticated && state.user != null) {
        _appLifeCycleObserver = AppLifeCycleObserver(userId: state.user!.uid, chatRepository: getIt<ChatRepository>());
      }
      WidgetsBinding.instance.addObserver(_appLifeCycleObserver);
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: RoutesName.splash,
      onGenerateRoute: RouteConfigs.generateRoute,
      navigatorKey: getIt<AppRouter>().navigatorKey,
    );
  }
}