import 'package:flutter/material.dart';
import '../../../../core/app/app_spacing.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/utils/constants/asset_paths.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _moveToNextScreen();
  }

  Future<void> _moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushReplacementNamed(context, RoutesName.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(AssetPaths.splashLogoPng),
            SizedBox(
              width: AppSpacing.screenWidth(context) * 0.5,
              child: LinearProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
