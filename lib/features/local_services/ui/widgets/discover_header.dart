import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DiscoverHeader extends StatelessWidget {
  const DiscoverHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'local_services.curated_for_you'.tr(),
          style: TextStyle(
            fontSize: 10.sp,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w400,
            letterSpacing: 2,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'local_services.discover_local_essentials'.tr().replaceAll('<br/>', '\n'),
          style: TextStyle(
            fontSize: 36.sp,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}