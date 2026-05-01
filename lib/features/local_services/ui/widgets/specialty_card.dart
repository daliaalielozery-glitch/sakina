import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina/core/theme/app_colors.dart';

class SpecialtyCard extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const SpecialtyCard({
    super.key,
    required this.title,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 105.w,
        height: 160.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.fontColor : const Color(0xFFF5F3F0),
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 24.h,
              width: double.infinity,
              color: isSelected
                  ? const Color(0xFFF7E0B6)
                  : const Color(0xFF4C463C),
            ),
            SizedBox(height: 32.h),
            Text(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.fontColor,
                fontSize: 16.sp,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
