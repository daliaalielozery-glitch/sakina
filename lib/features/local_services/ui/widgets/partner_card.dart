import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina/core/theme/app_colors.dart';
import 'package:sakina/features/local_services/ui/widgets/service_model.dart';

class PartnerCard extends StatelessWidget {
  final String title;
  final String description;
  final String rating;
  final List<String> tags;
  final String imageUrl;
  final VoidCallback onAction;

  final ServiceCategory category;

  const PartnerCard({
    super.key,
    required this.title,
    required this.description,
    required this.rating,
    required this.tags,
    required this.imageUrl,
    required this.onAction,
    this.category = ServiceCategory.all,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Image.network(
              imageUrl,
              height: 178.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF6D5C3B),
                  borderRadius: BorderRadius.circular(2.r),
                ),
                child: Text(
                  'local_services.verified'.tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Icon(Icons.star, size: 12.sp, color: const Color(0xFF4C463C)),
              SizedBox(width: 4.w),
              Text(
                rating,
                style: TextStyle(
                  color: const Color(0xFF4C463C),
                  fontSize: 12.sp,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: TextStyle(
              color: AppColors.fontColor,
              fontSize: 30.sp,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            description,
            style: TextStyle(
              color: const Color(0xFF4C463C),
              fontSize: 16.sp,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w400,
              height: 1.6,
            ),
          ),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 8.w,
            children: tags.map((tag) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAE8E5),
                  borderRadius: BorderRadius.circular(2.r),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: const Color(0xFF4C463C),
                    fontSize: 12.sp,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2C2005),
                foregroundColor: const Color(0xFFF7E0B6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    category == ServiceCategory.maintenance ? 'REQUEST QUOTE' : 'DETAILS',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(Icons.arrow_forward, size: 16.sp),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
