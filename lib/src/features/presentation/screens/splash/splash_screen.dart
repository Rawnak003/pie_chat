import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/app/app_spacing.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/routes/router.dart';
import '../../../../core/utils/constants/asset_paths.dart';
import '../../../../core/utils/utils/utils.dart';
import '../../../data/services/service_locator.dart';
import '../../../logic/cubits/auth/auth_cubit.dart';
import '../../../logic/cubits/auth/auth_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
        bloc: getIt<AuthCubit>(),
        listener: (context, state) async {
          await Future.delayed(const Duration(seconds: 2));
          if (state.status == AuthStatus.authenticated) {
            getIt<AppRouter>().pushReplacementNamed(RoutesName.home);
          } else if (state.status == AuthStatus.error && state.error != null) {
            Utils.showSnackBar(context, message: state.error!);
          } else {
            getIt<AppRouter>().pushReplacementNamed(RoutesName.signIn);
          }
        },
        builder: (context, state) {
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
    );
  }
}
