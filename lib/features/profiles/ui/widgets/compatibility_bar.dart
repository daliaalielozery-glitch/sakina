import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina/core/theme/app_colors.dart';

class CompatibilityBar extends StatelessWidget {
  final String label;
  final double progress;

  const CompatibilityBar({
    super.key,
    required this.label,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.fontColor,
            fontSize: 14.sp,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          width: 128.w,
          height: 4.h,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFF6A624F).withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBrown),
            ),
          ),
        ),
      ],
    );
  }
}
