import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina/core/theme/app_colors.dart';
import 'package:sakina/features/profiles/ui/widgets/preference_card.dart';

class PreferencesSection extends StatelessWidget {
  const PreferencesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3F0),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Preferences',
                style: TextStyle(
                  color: AppColors.fontColor,
                  fontSize: 20.sp,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Edit All',
                  style: TextStyle(
                    color: const Color(0xFF9A8762),
                    fontSize: 14.sp,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              const PreferenceCard(
                icon: Icons.nightlight_outlined,
                label: 'Schedule',
                value: 'Night Owl',
              ),
              SizedBox(width: 12.w),
              const PreferenceCard(
                icon: Icons.volume_off_outlined,
                label: 'Noise Level',
                value: 'Quiet',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
