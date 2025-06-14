import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piechat/src/core/app/app_spacing.dart';
import 'package:piechat/src/core/utils/constants/colors.dart';
import 'package:piechat/src/core/utils/constants/strings.dart';
import 'package:piechat/src/features/data/services/service_locator.dart';
import 'package:piechat/src/features/logic/cubits/auth/auth_cubit.dart';

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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _emailFocusNode = FocusNode();
  final _nameFocusNode = FocusNode();
  final _userNameFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _userNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _nameFocusNode.dispose();
    _userNameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
  }

  void _onTapSignIn() {
    getIt<AppRouter>().pop();
  }

  Future<void> _onTapSignUp() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      try {
        await getIt<AuthCubit>().signUp(
          email: _emailController.text,
          fullName: _nameController.text,
          username: _userNameController.text,
          phoneNumber: _phoneController.text,
          password: _passwordController.text,
        );
        Utils.showSnackBar(context, message: AppStrings.signUpSuccessful);
      } catch (e) {
        Utils.showSnackBar(context, message: e.toString());
      }
    }
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
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: AppSpacing.screenHeight(context) * 0.1),
                      Text(
                        AppStrings.createAccount,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: AppSpacing.screenHeight(context) * 0.01),
                      Text(
                        AppStrings.signUpToContinue,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(color: AppColor.greyColor),
                      ),
                      SizedBox(height: AppSpacing.screenHeight(context) * 0.05),
                      TextFormField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText: AppStrings.email,
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: InputValidators.emailValidator,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      SizedBox(height: AppSpacing.screenHeight(context) * 0.02),
                      TextFormField(
                        controller: _nameController,
                        focusNode: _nameFocusNode,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText: AppStrings.fullName,
                          prefixIcon: Icon(Icons.perm_identity_outlined),
                        ),
                        validator:
                            (value) => InputValidators.nameValidator(
                              AppStrings.fullName,
                              value,
                            ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      SizedBox(height: AppSpacing.screenHeight(context) * 0.02),
                      TextFormField(
                        controller: _userNameController,
                        focusNode: _userNameFocusNode,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText: AppStrings.username,
                          prefixIcon: Icon(Icons.alternate_email_outlined),
                        ),
                        validator:
                            (value) => InputValidators.nameValidator(
                              AppStrings.username,
                              value,
                            ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      SizedBox(height: AppSpacing.screenHeight(context) * 0.02),
                      TextFormField(
                        controller: _phoneController,
                        focusNode: _phoneFocusNode,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText: AppStrings.phone,
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                        validator: InputValidators.phoneValidator,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      SizedBox(height: AppSpacing.screenHeight(context) * 0.02),
                      TextFormField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          hintText: AppStrings.password,
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                        validator: InputValidators.passwordValidator,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      SizedBox(height: AppSpacing.screenHeight(context) * 0.03),
                      Visibility(
                        visible: state.status != AuthStatus.loading,
                        replacement: Center(child: CircularProgressIndicator()),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _onTapSignUp(),
                            child: const Text(AppStrings.signUp),
                          ),
                        ),
                      ),
                      SizedBox(height: AppSpacing.screenHeight(context) * 0.05),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: AppStrings.alreadyHaveAccount,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColor.greyColor,
                            ),
                            children: [
                              TextSpan(
                                text: AppStrings.signIn,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyLarge?.copyWith(
                                  color: AppColor.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer:
                                    TapGestureRecognizer()..onTap = _onTapSignIn,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
