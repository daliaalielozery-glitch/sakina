import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina/core/theme/app_colors.dart';
import 'package:sakina/core/widgets/custom_app_button.dart';
import 'package:sakina/core/widgets/custom_text_form_field.dart';
import 'package:sakina/core/widgets/custom_text_rich.dart';
import 'package:sakina/features/auth/bloc/auth_bloc.dart';
import 'package:sakina/features/auth/bloc/auth_event.dart';
import 'package:sakina/features/auth/bloc/auth_state.dart';
import 'package:sakina/features/auth/repository/auth_repository.dart';
import 'package:sakina/features/auth/widgets/custom_gender_dropdown.dart';
import 'package:sakina/features/auth/widgets/social_auth_buttons.dart';
import 'package:sakina/features/auth/login_screen.dart';
import 'package:sakina/features/auth/widgets/terms_and_conditions_section.dart';
import 'package:sakina/generated/locale_keys.g.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController universityController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? selectedGender; 
  bool isAgreed = false;

  @override
  void dispose() {
    nameController.dispose();
    universityController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(AuthRepository()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          } else if (state is AuthSuccess) {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is AuthFailure) {
            Navigator.pop(context);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.themeColor,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30.h),
                    Text(
                      LocaleKeys.signup_header.tr(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        letterSpacing: 1.2,
                        color: AppColors.primaryBrown,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      LocaleKeys.signup_title.tr(),
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // RichedText
                    Customtextrich(
                      tapped: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const LoginScreen(role: 'student'),
                        ),
                      ),
                      textTitle: LocaleKeys.signup_subtitle.tr(),
                      textButton: LocaleKeys.signup_signin_link.tr(),
                    ),

                    SizedBox(height: 30.h),

                    // full name
                    CustomTextFormField(
                      controller: nameController,
                      hintText: LocaleKeys.signup_full_name_placeholder.tr(),
                      labelText: LocaleKeys.signup_full_name_label.tr(),
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                    ),
                    SizedBox(height: 20.h),

                    // university
                    CustomTextFormField(
                      controller: universityController,
                      hintText: LocaleKeys.signup_university_placeholder.tr(),
                      labelText: LocaleKeys.signup_university_label.tr(),
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                    ),
                    SizedBox(height: 20.h),

                    // email
                    CustomTextFormField(
                      controller: emailController,
                      hintText: LocaleKeys.signup_university_email_placeholder
                          .tr(),
                      labelText: LocaleKeys.signup_university_email_label.tr(),
                      keyboardType: TextInputType.emailAddress,
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                    ),
                    SizedBox(height: 20.h),

                    // password
                    CustomTextFormField(
                      controller: passwordController,
                      hintText: "........",
                      labelText: LocaleKeys.signup_password_label.tr(),
                      secured: true,
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 20.sp),
                    ),

                    SizedBox(height: 20.h),

                    // gender field
                    CustomGenderDropdown(
                      value: selectedGender,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                    ),

                    SizedBox(height: 15.h),

                    // terms & conditions checkbox
                    TermsAndConditionsSection(
                      value: isAgreed,
                      text: LocaleKeys.signup_terms_text.tr(),
                      onChanged: (value) {
                        setState(() {
                          isAgreed = value!;
                        });
                      },
                    ),

                    SizedBox(height: 25.h),

                    // sign up button
                    Builder(
                      builder: (context) => CustomAppButton(
                        text: LocaleKeys.signup_title.tr(),
                        onPressed: () {
                          context.read<AuthBloc>().add(
                            SignUpRequested(
                              email: emailController.text,
                              password: passwordController.text,
                              fullName: nameController.text,
                              university: universityController.text,
                              gender: selectedGender, 
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 30.h),

                    SocialAuthButtons(
                      googleLabel: LocaleKeys.signup_google_auth.tr(),
                      appleLabel: LocaleKeys.signup_eduid_auth.tr(),
                      onGoogleTap: () {},
                      onAppleTap: () {},
                    ),

                    SizedBox(height: 30.h),

                    // Footer (Copyright)
                    Center(
                      child: Text(
                        LocaleKeys.signup_copyright.tr(),
                        style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
