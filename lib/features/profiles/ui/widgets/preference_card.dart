import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina/core/theme/app_colors.dart';

class PreferenceCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const PreferenceCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primaryBrown, size: 20.sp),
            SizedBox(height: 8.h),
            Text(
              label.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF4C463C),
                fontSize: 12.sp,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w400,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.fontColor,
                fontSize: 16.sp,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
