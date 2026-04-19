import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina/core/theme/app_colors.dart';
import 'package:sakina/features/role/ui/role_screen.dart';
import 'package:sakina/generated/locale_keys.g.dart';

class GoToHomeButton extends StatelessWidget {
  const GoToHomeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return      Positioned(
            bottom: 20,
            right: 30,
            left: 30,
            child: InkWell(
  borderRadius: BorderRadius.circular(20.r),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoleScreen(),
      ),
    );
  },
  child: Container(
    height: 60.h,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20.r),
      color: AppColors.primaryBrown,
    ),
    child: Row(
      children: [
        Spacer(),
        Text(
          LocaleKeys.get_started.tr(),
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        SizedBox(width: 3.w),
        Icon(Icons.arrow_forward, color: Colors.white, size: 20.r),
        Spacer(),
      ],
    ),
  ),
),
          )
     ;
  }
}