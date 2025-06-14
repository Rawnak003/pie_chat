import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:piechat/src/core/app/app_spacing.dart';
import 'package:piechat/src/core/utils/constants/colors.dart';
import 'package:piechat/src/core/utils/constants/strings.dart';

import '../../../../../core/utils/validators/input_validators.dart';

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
    Navigator.pop(context);
  }

  void _onTapSignUp() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      //TODO Perform sign up logic here
      Navigator.pop(context);
    }
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
                    AppStrings.createAccount,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold,),
                  ),
                  SizedBox(height: AppSpacing.screenHeight(context) * 0.01),
                  Text(
                    AppStrings.signUpToContinue,
                    style: Theme.of(context,).textTheme.bodyLarge?.copyWith(color: AppColor.greyColor),
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
                    validator: (value) => InputValidators.nameValidator(AppStrings.fullName, value),
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
                    validator: (value) => InputValidators.nameValidator(AppStrings.username, value),
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
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      hintText: AppStrings.password,
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    validator: InputValidators.passwordValidator,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  SizedBox(height: AppSpacing.screenHeight(context) * 0.03),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(onPressed: () => _onTapSignUp(), child: Text(AppStrings.signUp)),
                  ),
                  SizedBox(height: AppSpacing.screenHeight(context) * 0.05),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: AppStrings.alreadyHaveAccount,
                        style: Theme.of(context,).textTheme.bodyLarge?.copyWith(color: AppColor.greyColor),
                        children: [
                          TextSpan(
                            text: AppStrings.signIn,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColor.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()..onTap = _onTapSignIn,
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
