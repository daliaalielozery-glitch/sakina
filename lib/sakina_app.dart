import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina/features/auth/bloc/auth_bloc.dart';
import 'package:sakina/features/auth/repository/auth_repository.dart';
import 'package:sakina/features/onboarding/main_onboarding.dart';
import 'package:sakina/pages/home.dart';
import 'package:sakina/bill_popup/utilitybill.dart';
import 'main.dart';

class SakinaApp extends StatelessWidget {
  const SakinaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 884),
      minTextAdapt: true,
      splitScreenMode: true,
      child: BlocProvider(
        create: (_) => AuthBloc(AuthRepository()),
        child: MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          home: UtilityBillScreen(),
          routes: {
            '/utility-bill': (context) => const UtilityBillScreen(),
          },
        ),
      ),
    );
  }
}
