import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:piechat/src/core/app/app_spacing.dart';
import 'package:piechat/src/core/utils/constants/colors.dart';
import 'package:piechat/src/core/utils/constants/strings.dart';

import '../../../../../core/utils/validators/input_validators.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }
  @override
  Widget build(BuildContext context) {
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
                    AppStrings.welcome,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold,),
                  ),
                  SizedBox(height: AppSpacing.screenHeight(context) * 0.01),
                  Text(
                    AppStrings.signIntoContinue,
                    style: Theme.of(context,).textTheme.bodyLarge?.copyWith(color: AppColor.greyColor),
                  ),
                  SizedBox(height: AppSpacing.screenHeight(context) * 0.05),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: AppStrings.email,
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: InputValidators.emailValidator,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  SizedBox(height: AppSpacing.screenHeight(context) * 0.02),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: AppStrings.password,
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: Icon(Icons.visibility),
                    ),
                    validator: InputValidators.passwordValidator,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  SizedBox(height: AppSpacing.screenHeight(context) * 0.01),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(AppStrings.forgotPassword),
                    ),
                  ),
                  SizedBox(height: AppSpacing.screenHeight(context) * 0.02),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(onPressed: () {}, child: Text(AppStrings.login)),
                  ),
                  SizedBox(height: AppSpacing.screenHeight(context) * 0.05),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: AppStrings.dontHaveAccount,
                        style: Theme.of(context,).textTheme.bodyLarge?.copyWith(color: AppColor.greyColor),
                        children: [
                          TextSpan(
                            text: AppStrings.signUp,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColor.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()..onTap = () {},
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
}
