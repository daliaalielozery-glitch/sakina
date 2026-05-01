import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina/core/theme/app_colors.dart';

class PrivacySection extends StatelessWidget {
  final bool showProfileToPublic;
  final ValueChanged<bool> onToggle;

  const PrivacySection({
    super.key,
    required this.showProfileToPublic,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3F0),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Privacy',
            style: TextStyle(
              color: AppColors.fontColor,
              fontSize: 20.sp,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Show Profile to Public',
                style: TextStyle(
                  color: const Color(0xFF1B1C1A),
                  fontSize: 14.sp,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w400,
                ),
              ),
              Switch(
                value: showProfileToPublic,
                onChanged: onToggle,
                activeTrackColor: AppColors.fontColor,
                inactiveTrackColor: const Color(0xFFE4E2DF),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
