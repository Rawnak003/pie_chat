import 'package:flutter/material.dart';
import '../routes/route_configs.dart';
import '../routes/route_names.dart';
import '../utils/constants/strings.dart';
import 'app_theme.dart';

class PieChat extends StatefulWidget {
  const PieChat({super.key});

  @override
  State<PieChat> createState() => _PieChatState();
}

class _PieChatState extends State<PieChat> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: RoutesName.splash,
      onGenerateRoute: RouteConfigs.generateRoute,
    );
  }
}