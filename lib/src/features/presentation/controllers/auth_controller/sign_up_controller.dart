import 'package:flutter/material.dart';

import '../../../../core/routes/router.dart';
import '../../../../core/utils/constants/strings.dart';
import '../../../../core/utils/utils/utils.dart';
import '../../../data/services/service_locator.dart';
import '../../../logic/cubits/auth/auth_cubit.dart';

class SignUpController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final emailFocusNode = FocusNode();
  final nameFocusNode = FocusNode();
  final userNameFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  void dispose() {
    emailController.dispose();
    nameController.dispose();
    userNameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    nameFocusNode.dispose();
    userNameFocusNode.dispose();
    phoneFocusNode.dispose();
    passwordFocusNode.dispose();
  }

  void onTapSignIn(BuildContext context) {
    getIt<AppRouter>().pop();
  }

  Future<void> onTapSignUp(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (formKey.currentState!.validate()) {
      try {
        await getIt<AuthCubit>().signUp(
          email: emailController.text,
          fullName: nameController.text,
          username: userNameController.text,
          phoneNumber: phoneController.text,
          password: passwordController.text,
        );
        Utils.showSnackBar(context, message: AppStrings.signUpSuccessful);
      } catch (e) {
        Utils.showSnackBar(context, message: e.toString());
      }
    }
  }
}