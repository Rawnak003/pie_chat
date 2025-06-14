import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piechat/src/core/app/app_spacing.dart';
import 'package:piechat/src/core/utils/constants/colors.dart';
import 'package:piechat/src/core/utils/constants/strings.dart';
import 'package:piechat/src/features/data/services/service_locator.dart';
import 'package:piechat/src/features/logic/cubits/auth/auth_cubit.dart';
import 'package:piechat/src/features/presentation/controllers/auth_controller/sign_up_controller.dart';

import '../../../../../core/routes/route_names.dart';
import '../../../../../core/routes/router.dart';
import '../../../../../core/utils/utils/utils.dart';
import '../../../../../core/utils/validators/input_validators.dart';
import '../../../../logic/cubits/auth/auth_state.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final SignUpController controller;

  @override
  void initState() {
    super.initState();
    controller = SignUpController();
  }

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
                        AppStrings.createAccount,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: AppSpacing.screenHeight(context) * 0.01),
                      Text(
                        AppStrings.signUpToContinue,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColor.greyColor,
                        ),
                      ),
                      SizedBox(height: AppSpacing.screenHeight(context) * 0.05),
                      _buildEmailField(),
                      SizedBox(height: AppSpacing.screenHeight(context) * 0.02),
                      _buildNameField(),
                      SizedBox(height: AppSpacing.screenHeight(context) * 0.02),
                      _buildUsernameField(),
                      SizedBox(height: AppSpacing.screenHeight(context) * 0.02),
                      _buildPhoneField(),
                      SizedBox(height: AppSpacing.screenHeight(context) * 0.02),
                      _buildPasswordField(),
                      SizedBox(height: AppSpacing.screenHeight(context) * 0.03),
                      _buildSignUpButton(state),
                      SizedBox(height: AppSpacing.screenHeight(context) * 0.05),
                      _buildSignInText(),
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

  Widget _buildSignInText() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: AppStrings.alreadyHaveAccount,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppColor.greyColor),
          children: [
            TextSpan(
              text: AppStrings.signIn,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColor.primaryColor,
                fontWeight: FontWeight.bold,
              ),
              recognizer:
                  TapGestureRecognizer()
                    ..onTap = () => controller.onTapSignIn(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpButton(AuthState state) {
    return Visibility(
      visible: state.status != AuthStatus.loading,
      replacement: Center(child: CircularProgressIndicator()),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => controller.onTapSignUp(context),
          child: const Text(AppStrings.signUp),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: controller.passwordController,
      focusNode: controller.passwordFocusNode,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
        hintText: AppStrings.password,
        prefixIcon: Icon(Icons.lock_outline),
      ),
      validator: InputValidators.passwordValidator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: controller.phoneController,
      focusNode: controller.phoneFocusNode,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        hintText: AppStrings.phone,
        prefixIcon: Icon(Icons.phone_outlined),
      ),
      validator: InputValidators.phoneValidator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      controller: controller.userNameController,
      focusNode: controller.userNameFocusNode,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        hintText: AppStrings.username,
        prefixIcon: Icon(Icons.alternate_email_outlined),
      ),
      validator:
          (value) => InputValidators.nameValidator(AppStrings.username, value),
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: controller.nameController,
      focusNode: controller.nameFocusNode,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        hintText: AppStrings.fullName,
        prefixIcon: Icon(Icons.perm_identity_outlined),
      ),
      validator:
          (value) => InputValidators.nameValidator(AppStrings.fullName, value),
      autovalidateMode: AutovalidateMode.onUserInteraction,
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
}
