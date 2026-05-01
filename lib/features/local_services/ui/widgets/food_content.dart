import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina/core/theme/app_colors.dart';
import 'package:sakina/features/local_services/ui/quick_wash_laundry_details_screen.dart';
import 'package:sakina/features/local_services/ui/widgets/service_card.dart';

class FoodContent extends StatefulWidget {
  const FoodContent({super.key});

  @override
  State<FoodContent> createState() => _FoodContentState();
}

class _FoodContentState extends State<FoodContent> {
  String _selectedFoodCategory = 'all';
  final foodCategories = ['all', 'egyptian', 'italian', 'healthy', 'quick_bites'];

  // البيانات اللي كانت عندك في الكود الأصلي
  final List<Map<String, dynamic>> allFoodItems = [
    {'title': 'local_services.mamas_kitchen', 'desc': 'local_services.trad_egyptian', 'rating': '4.9', 'dist': 'local_services.home_style', 'img': 'https://placehold.co/342x214/png', 'cat': 'egyptian'},
    {'title': 'local_services.university_bites', 'desc': 'local_services.pizza_grill', 'rating': '4.5', 'dist': 'local_services.fast_casual', 'img': 'https://placehold.co/342x214/png', 'cat': 'italian'},
    {'title': 'local_services.zamalek_food_court', 'desc': 'local_services.med_continental', 'rating': '4.8', 'dist': 'local_services.premium', 'img': 'https://placehold.co/342x214/png', 'cat': 'healthy'},
    {'title': 'local_services.heritage_kitchen', 'desc': 'local_services.heritage_desc', 'rating': '4.9', 'dist': '1.2km away', 'img': 'https://placehold.co/342x192/png', 'cat': 'egyptian'},
  ];

  @override
  Widget build(BuildContext context) {
    final filteredItems = _selectedFoodCategory == 'all'
        ? allFoodItems
        : allFoodItems.where((item) => item['cat'] == _selectedFoodCategory).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: foodCategories.map((cat) {
              final isSelected = _selectedFoodCategory == cat;
              return Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: ChoiceChip(
                  label: Text('local_services.$cat'.tr()),
                  selected: isSelected,
                  onSelected: (val) => setState(() => _selectedFoodCategory = cat),
                  backgroundColor: AppColors.unSelectedChip,
                  selectedColor: AppColors.primaryBeig,
                  showCheckmark: false,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 32.h),
        // عرض الكروت المفلترة
        ...filteredItems.map((item) => ServiceCard(
              title: (item['title'] as String).tr(),
              description: (item['desc'] as String).tr(),
              rating: item['rating'],
              distance: item['dist'],
              imageUrl: item['img'],
              priceRange: 'DETAILS',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QuickWashLaundryDetailsScreen()),
                );
              },
            )),
      ],
    );
  }
}