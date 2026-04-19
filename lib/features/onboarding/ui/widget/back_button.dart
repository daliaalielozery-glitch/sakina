import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sakina/core/theme/app_colors.dart';
import 'package:sakina/generated/locale_keys.g.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key, required this.backTapped});
  final void Function() backTapped;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed:backTapped,
      child: Text(
        LocaleKeys.back.tr(),
        style: TextStyle(color: AppColors.primaryBrown),
      ),
    );
  }
}
