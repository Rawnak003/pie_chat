import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piechat/src/core/app/app_spacing.dart';
import 'package:piechat/src/core/routes/router.dart';
import 'package:piechat/src/core/utils/constants/colors.dart';
import 'package:piechat/src/core/utils/constants/strings.dart';
import 'package:piechat/src/features/data/services/service_locator.dart';

import '../../../../../core/routes/route_names.dart';
import '../../../../../core/utils/utils/utils.dart';
import '../../../../../core/utils/validators/input_validators.dart';
import '../../../../logic/cubits/auth/auth_cubit.dart';
import '../../../../logic/cubits/auth/auth_state.dart';
import '../../../controllers/auth_controller/sign_in_controller.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final SignInController controller = SignInController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      bloc: getIt<AuthCubit>(),
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          getIt<AppRouter>().pushNamedAndRemoveUntil(
            RoutesName.home,
            (route) => false,
          );
        } else if (state.status == AuthStatus.error && state.error != null) {
          Utils.showSnackBar(context, message: state.error!);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.verticalPadding * 3),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: AppSpacing.screenHeight(context) * 0.1),
                      Text(
                        AppStrings.welcome,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: AppSpacing.screenHeight(context) * 0.01),
                      Text(
                        AppStrings.signIntoContinue,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColor.greyColor,),
                      ),
                      SizedBox(height: AppSpacing.screenHeight(context) * 0.05),
                      _buildEmailField(),
                      SizedBox(height: AppSpacing.screenHeight(context) * 0.02),
                      _buildPasswordField(),
                      SizedBox(height: AppSpacing.screenHeight(context) * 0.01),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => controller.onTapForgotPassword(context),
                          child: Text(AppStrings.forgotPassword),
                        ),
                      ),
                      SizedBox(height: AppSpacing.screenHeight(context) * 0.02),
                      _buildLoginButton(state),
                      SizedBox(height: AppSpacing.screenHeight(context) * 0.05),
                      _buildSignUpText(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: controller.emailController,
      focusNode: controller.emailFocusNode,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        hintText: AppStrings.email,
        prefixIcon: Icon(Icons.email_outlined),
      ),
      validator: InputValidators.emailValidator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: controller.passwordController,
      focusNode: controller.passwordFocusNode,
      textInputAction: TextInputAction.done,
      obscureText: controller.passwordObscureText,
      decoration: InputDecoration(
        hintText: AppStrings.password,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          onPressed:
              () => controller.togglePasswordVisibility(() => setState(() {})),
          icon:
              controller.passwordObscureText
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off),
        ),
      ),
      validator: InputValidators.passwordValidator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget _buildLoginButton(AuthState state) {
    return Visibility(
      visible: state.status != AuthStatus.loading,
      replacement: Center(child: CircularProgressIndicator()),
      child: SizedBox(
        width: double.infinity,
        height: AppSpacing.screenHeight(context) * 0.06,
        child: ElevatedButton(
          onPressed: () => controller.onTapLogin(context),
          child: const Text(AppStrings.login),
        ),
      ),
    );
  }

  Widget _buildSignUpText() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: AppStrings.dontHaveAccount,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppColor.greyColor),
          children: [
            TextSpan(
              text: AppStrings.signUp,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColor.primaryColor,
                fontWeight: FontWeight.bold,
              ),
              recognizer:
                  TapGestureRecognizer()
                    ..onTap = () => controller.onTapSignUp(context),
            ),
          ],
        ),
      ),
    );
  }
}
