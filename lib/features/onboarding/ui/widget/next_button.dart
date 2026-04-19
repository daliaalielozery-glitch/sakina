import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina/core/theme/app_colors.dart';
import 'package:sakina/generated/locale_keys.g.dart';

class CustomNextButton extends StatelessWidget {
  const CustomNextButton({super.key, this.tappedNext});
final void Function()? tappedNext;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed:tappedNext,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            LocaleKeys.next.tr(),
            style: TextStyle(color: AppColors.primaryBrown),
          ),
          SizedBox(width: 10.w),
          Icon(Icons.arrow_forward, color: Colors.brown),
        ],
      ),
    );
  }
}
