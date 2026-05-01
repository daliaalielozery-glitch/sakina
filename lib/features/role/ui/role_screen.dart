import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sakina/generated/locale_keys.g.dart';

import 'widgets/role_custom_button.dart';

class RoleScreen extends StatelessWidget {
  const RoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final titleSize = (w * 0.05).clamp(24.0, 40.0);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              LocaleKeys.choose_role.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            RoleCustomButton(buttonText: LocaleKeys.tenant.tr(), buttonColor: const Color(0xff6D5C3B), role: 'tenant'),
            const SizedBox(height: 12),
            RoleCustomButton(buttonText: LocaleKeys.landlord.tr(), buttonColor: const Color(0xff4C463C), role: 'landlord'),
          ],
        ),
      ),
    );
  }
}
