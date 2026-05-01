import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina/core/theme/app_colors.dart';

import 'package:sakina/features/local_services/ui/widgets/service_model.dart';

class CategorySelector extends StatelessWidget {
  final ServiceCategory selectedCategory;
  final Function(ServiceCategory) onCategorySelected;

  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: ServiceCategory.values.map((category) {
          final isSelected = selectedCategory == category;
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: InkWell(
              onTap: () => onCategorySelected(category),
              borderRadius: BorderRadius.circular(4.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryBeig : AppColors.unSelectedChip,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  'local_services.${category.name}'.tr(),
                  style: TextStyle(
                    color: isSelected ? AppColors.bottomNavigationBarColor : const Color(0xFF4C463C),
                    fontSize: 14.sp,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
