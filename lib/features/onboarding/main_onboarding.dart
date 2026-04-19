import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sakina/features/onboarding/ui/widget/custom_onboarding.dart';
import 'package:sakina/generated/locale_keys.g.dart';

class MainOnboarding extends StatefulWidget {
  const MainOnboarding({super.key});

  @override
  State<MainOnboarding> createState() => _MainOnboardingState();
}

class _MainOnboardingState extends State<MainOnboarding> {
  final CarouselSliderController controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    List<Widget> onboardingList = [
      CustomOnboarding(
        url: "assets/pictures/onboarding1.png",
        title: LocaleKeys.right_place.tr(),
        description: LocaleKeys.search_description.tr(),
        stepPath: "assets/icons/step1.svg",
        backButton: false,
        nextButton: true,
        getStartButton: false,
        nextTapped: () => controller.nextPage(),
      ),
      CustomOnboarding(
        url: "assets/pictures/onboarding2.png",
        title: LocaleKeys.verified_safe.tr(),
        description: LocaleKeys.verified_description.tr(),
        stepPath: "assets/icons/step2.svg",
        backButton: true,
        nextButton: true,
        getStartButton: false,
        nextTapped: () => controller.nextPage(),
        backTapped: () => controller.previousPage(),
      ),
      CustomOnboarding(
        url: "assets/pictures/onboarding3.png",
        title: LocaleKeys.discover_services.tr(),
        description: LocaleKeys.find_place.tr(),
        stepPath: "assets/icons/step3.svg",
        backButton: true,
        nextButton: true,
        getStartButton: false,
        nextTapped: () => controller.nextPage(),
        backTapped: () => controller.previousPage(),
      ),
      CustomOnboarding(
        url: "assets/pictures/onboarding4.png",
        title: LocaleKeys.get_started.tr(),
        description: LocaleKeys.find_place.tr(),
        stepPath: "assets/icons/step3.svg", 
        backButton: true,
        nextButton: false,
        getStartButton: true,
        backTapped: () => controller.previousPage(),
      ),
    ];

    return Scaffold(
      body: CarouselSlider(
        carouselController: controller,
        items: onboardingList,
        options: CarouselOptions(
          padEnds: false,
          height: double.infinity,
          viewportFraction: 1,
          pageSnapping: true,
          enableInfiniteScroll: false,
          scrollPhysics: const NeverScrollableScrollPhysics(), 
        ),
      ),
    );
  }
}