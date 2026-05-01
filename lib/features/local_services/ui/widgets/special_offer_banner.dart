import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina/core/theme/app_colors.dart';

class SpecialOfferBanner extends StatelessWidget {
  const SpecialOfferBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        color: AppColors.fontColor,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'local_services.special_offer'.tr(),
            style: TextStyle(
              color: const Color(0xFF9A8762),
              fontSize: 10.sp,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w400,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'local_services.new_semester_discount'.tr(),
            style: TextStyle(
              color: const Color(0xFFF7E0B6),
              fontSize: 24.sp,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'local_services.semester_discount_desc'.tr(),
            style: TextStyle(
              color: const Color(0xFFE4E2DF),
              fontSize: 14.sp,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF7E0B6),
              foregroundColor: const Color(0xFF251A02),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              elevation: 0,
            ),
            child: Text(
              'local_services.claim_now'.tr(),
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
