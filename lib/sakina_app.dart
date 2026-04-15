import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
<<<<<<< HEAD
import 'package:sakina/features/dalia/login/ui/login_screen.dart';
import 'package:sakina/features/dalia/onboarding/ui/first_onboarding_screens.dart';
import 'package:sakina/features/dalia/onboarding/ui/fourth_onboarding_screens.dart';
import 'package:sakina/features/dalia/onboarding/ui/third_onboarding_screens.dart';
import 'package:sakina/features/dalia/role/ui/role_screen.dart';

=======
import 'package:sakina/features/onboarding/ui/onboarding_screens.dart';
>>>>>>> 8f9cdcd59d37c5815a6a267e454ff4baf7e7d6c4
class SakinaApp extends StatelessWidget {
  const SakinaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 884),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
<<<<<<< HEAD
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: FirstOnboardingScreens(),
      ),
    );
  }
}
=======
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
        home: OnboardingScreens() ,
      ),
    );
  }
}
>>>>>>> 8f9cdcd59d37c5815a6a267e454ff4baf7e7d6c4
