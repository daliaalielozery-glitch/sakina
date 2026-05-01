import 'package:flutter/material.dart';
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
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final cardHeight = h * 0.50;
    final titleSize = (w * 0.045).clamp(24.0, 40.0);
    final bodySize = (w * 0.028).clamp(16.0, 24.0);
    final svgHeight = (h * 0.03).clamp(18.0, 32.0);
    final hPad = (w * 0.05).clamp(16.0, 40.0);

    return Stack(
      fit: StackFit.expand,
      children: [
        // ── Background image ───────────────────────────────────────────
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: cardHeight - 40,
          child: Image.asset(url, fit: BoxFit.cover),
        ),

        // ── Bottom card ────────────────────────────────────────────────
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: cardHeight,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            padding: EdgeInsets.fromLTRB(hPad, 16, hPad, 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.w700,
                    color: AppColors.fontColor,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: bodySize,
                    color: AppColors.fontColor,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                SvgPicture.asset(stepPath, height: svgHeight),
              ],
            ),
          ),
        ),

        // ── Navigation buttons ─────────────────────────────────────────
        Positioned(
          bottom: 16,
          left: hPad,
          right: hPad,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 80,
                child: backButton
                    ? CustomBackButton(backTapped: backTapped ?? () {})
                    : const SizedBox.shrink(),
              ),
              SizedBox(
                width: 100,
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