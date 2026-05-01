import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina/core/theme/app_colors.dart';

class SplitBillSection extends StatelessWidget {
  final bool electricitySplit;
  final bool waterSplit;
  final ValueChanged<bool> onElectricityToggle;
  final ValueChanged<bool> onWaterToggle;

  const SplitBillSection({
    super.key,
    required this.electricitySplit,
    required this.waterSplit,
    required this.onElectricityToggle,
    required this.onWaterToggle,
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
            'Split bill',
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
                'Electricity',
                style: TextStyle(
                  color: const Color(0xFF1B1C1A),
                  fontSize: 14.sp,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w400,
                ),
              ),
              Switch(
                value: electricitySplit,
                onChanged: onElectricityToggle,
                activeTrackColor: AppColors.fontColor,
                inactiveTrackColor: const Color(0xFFE4E2DF),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Water',
                style: TextStyle(
                  color: const Color(0xFF1B1C1A),
                  fontSize: 14.sp,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w400,
                ),
              ),
              Switch(
                value: waterSplit,
                onChanged: onWaterToggle,
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
