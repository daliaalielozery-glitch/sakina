import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina/core/theme/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String university;
  final String bio;
  final String imageUrl;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.university,
    required this.bio,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 192.w,
              height: 256.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              right: -10.w,
              bottom: -10.h,
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.fontColor,
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(Icons.edit, color: Colors.white, size: 18.sp),
              ),
            ),
          ],
        ),
        SizedBox(height: 32.h),
        Text(
          name,
          style: TextStyle(
            color: AppColors.fontColor,
            fontSize: 32.sp,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 4.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school_outlined,
                color: const Color(0xFF4C463C), size: 16.sp),
            SizedBox(width: 8.w),
            Text(
              university,
              style: TextStyle(
                color: const Color(0xFF4C463C),
                fontSize: 16.sp,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            bio,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF4C463C),
              fontSize: 16.sp,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
