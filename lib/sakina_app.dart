import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina/features/auth/bloc/auth_bloc.dart';
import 'package:sakina/features/auth/repository/auth_repository.dart';
import 'package:sakina/features/onboarding/main_onboarding.dart';
import 'package:sakina/features/role/ui/role_screen.dart';
import 'package:sakina/pages/home.dart';
import 'package:sakina/bill_popup/utilitybill.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sakina/core/widgets/bottom_bar.dart';
import 'package:sakina/landlord/host_profile_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class SakinaApp extends StatelessWidget {
  const SakinaApp({super.key});

  Widget _getHomeScreen(Session? session) {
    if (session == null) return MainOnboarding();
    final role = session.user.userMetadata?['role'];
    if (role == 'landlord') return HostProfileScreen();
    if (role == 'tenant') return const ButtomNavBarScreen();
    return const RoleScreen();
  }

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

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
          home: _getHomeScreen(session),
          routes: {
            '/home': (context) => const ButtomNavBarScreen(),
            '/landlord-home': (context) => HostProfileScreen(),
            '/utility-bill': (context) => const UtilityBillScreen(),
            '/role': (context) => const RoleScreen(),
          },
        ),
      ),
    );
  }
}