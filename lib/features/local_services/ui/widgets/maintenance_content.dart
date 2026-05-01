import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina/features/local_services/ui/widgets/partner_card.dart';
import 'package:sakina/features/local_services/ui/widgets/specialty_card.dart';
import 'package:sakina/features/local_services/ui/widgets/service_model.dart';

class MaintenanceContent extends StatelessWidget {
  const MaintenanceContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. العنوان الرئيسي للمحتوى (Premium Partners) يظهر مرة واحدة فقط في البداية
        _buildSectionTitle('local_services.premium_partners'.tr()),
        SizedBox(height: 24.h),

        // 2. Specialties Section
        _buildSectionTitle('local_services.specialties'.tr()),
        SizedBox(height: 24.h),
        Row(
          spacing: 15.w,
          children: [
            Expanded(
                child: SpecialtyCard(
                    title: 'local_services.plumbing'.tr(), onTap: () {})),
            Expanded(
                child: SpecialtyCard(
                    title: 'local_services.electrical'.tr(),
                    isSelected: true,
                    onTap: () {})),
            Expanded(
                child: SpecialtyCard(
                    title: 'local_services.furniture_assembly'.tr(),
                    onTap: () {})),
          ],
        ),
        SizedBox(height: 32.h),

        // 3. كل الـ Partner Cards تحت بعضها بدون تكرار العناوين
        PartnerCard(
          title: 'Elite Repairs'.tr(),
          description:
              'Specialized in premium European fixtures,smart home integration, and aestheticstructural maintenance.'
                  .tr(),
          rating: '4.8',
          tags: const ['Premium', 'European Fixtures'],
          imageUrl: 'https://placehold.co/385x168/png',
          category: ServiceCategory.maintenance,
          onAction: () {},
        ),

        SizedBox(height: 16.h), // مسافة بسيطة بين الكروت

        PartnerCard(
          title: 'local_services.profix_maintenance'.tr(),
          description: 'local_services.profix_partners_desc'.tr(),
          rating: '4.9',
          tags: const ['Emergency Repair', '12 Month Warranty'],
          imageUrl: 'https://placehold.co/385x168/png',
          category: ServiceCategory.maintenance,
          onAction: () {},
        ),

        SizedBox(height: 16.h),

        PartnerCard(
          title: 'local_services.handy_student'.tr(),
          description: 'local_services.handy_student_desc'.tr(),
          rating: '4.7',
          tags: const ['Affordable', 'Flat Rates'],
          imageUrl: 'https://placehold.co/385x168/png',
          category: ServiceCategory.maintenance,
          onAction: () {},
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Text(title,
            style: TextStyle(
                fontSize: 18.sp,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w700)),
        SizedBox(width: 16.w),
        const Expanded(child: Divider(color: Color(0x26CFC5B8))),
      ],
    );
  }
}
