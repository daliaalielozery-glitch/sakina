import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final Color? labelColor;

  const InfoCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: labelColor ?? const Color(0xFF4C463C), size: 20.sp),
          SizedBox(height: 12.h),
          Text(
            label,
            style: TextStyle(
              color: labelColor ?? const Color(0xFF4C463C),
              fontSize: 12.sp,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w400,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: 20.sp,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}