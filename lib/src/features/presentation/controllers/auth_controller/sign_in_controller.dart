import 'package:flutter/material.dart';

import '../../../../core/routes/route_names.dart';
import '../../../../core/routes/router.dart';
import '../../../../core/utils/constants/strings.dart';
import '../../../../core/utils/utils/utils.dart';
import '../../../data/services/service_locator.dart';
import '../../../logic/cubits/auth/auth_cubit.dart';

class SignInController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool passwordObscureText = true;

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
  }

  void onTapSignUp(BuildContext context) {
    getIt<AppRouter>().pushNamed(RoutesName.signUp);
  }

  Future<void> onTapLogin(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (formKey.currentState!.validate()) {
      try {
        await getIt<AuthCubit>().signIn(
          email: emailController.text,
          password: passwordController.text,
        );
        Utils.showSnackBar(context, message: AppStrings.loginSuccessful);
      } catch (e) {
        Utils.showSnackBar(context, message: e.toString());
      }
    }
  }

  void onTapForgotPassword(BuildContext context) {
    //TODO Perform forgot password logic here
  }

  void togglePasswordVisibility(VoidCallback updateState) {
    passwordObscureText = !passwordObscureText;
    updateState();
  }
}