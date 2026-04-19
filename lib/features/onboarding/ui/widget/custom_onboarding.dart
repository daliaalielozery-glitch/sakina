import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sakina/core/theme/app_colors.dart';
import 'package:sakina/features/onboarding/ui/widget/back_button.dart';
import 'package:sakina/features/onboarding/ui/widget/go_to_home_button.dart';
import 'package:sakina/features/onboarding/ui/widget/next_button.dart';

class CustomOnboarding extends StatelessWidget {
  const CustomOnboarding({
    super.key,
    required this.url,
    required this.description,
    required this.title,
    required this.backButton,
    required this.nextButton,
    required this.getStartButton,
    required this.stepPath,
    this.nextTapped,
    this.backTapped,
  });

  final String url;
  final String description;
  final String title;
  final String stepPath;
  final bool backButton;
  final bool nextButton;
  final bool getStartButton;
  final void Function()? nextTapped;
  final void Function()? backTapped;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Image.asset(
            url,
            fit: BoxFit.cover,
            width: 1.sw,
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            width: 1.sw,
            height: 480.h,
            decoration: const ShapeDecoration(
              color: AppColors.onBoardingContainerColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                Text(
                  title,
                  style: AppTheme.titleText,
                  textAlign: TextAlign.center,
                ),
                const Spacer(flex: 1),
                Text(
                  description,
                  style: AppTheme.bodyText,
                  textAlign: TextAlign.center,
                ),
                const Spacer(flex: 2),
                SvgPicture.asset(stepPath),
                const Spacer(flex: 4),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 30.h,
          left: 20.w,
          right: 20.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 80.w,
                child: backButton
                    ? CustomBackButton(backTapped: backTapped ?? () {})
                    : const SizedBox.shrink(),
              ),
              SizedBox(
                width: 100.w,
                child: nextButton
                    ? CustomNextButton(tappedNext: nextTapped)
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
        if (getStartButton) const GoToHomeButton(),
      ],
    );
  }
}