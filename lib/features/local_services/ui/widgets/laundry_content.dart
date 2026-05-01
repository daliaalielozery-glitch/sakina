import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sakina/features/local_services/ui/quick_wash_laundry_details_screen.dart';
import 'package:sakina/features/local_services/ui/widgets/service_card.dart';
import 'package:sakina/features/local_services/ui/widgets/service_model.dart';

class LaundryContent extends StatelessWidget {
  const LaundryContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const QuickWashLaundryDetailsScreen()),
          ),
          child: ServiceCard(category: ServiceCategory.laundry,
            title: 'local_services.quickwash_laundry'.tr(),
            description: 'local_services.quickwash_desc'.tr(),
            rating: '4.9',
            distance: 'local_services.premium_service'.tr(),
            imageUrl: 'https://placehold.co/342x256/png',
            tag: 'local_services.featured'.tr(),
            priceRange: 'EGP 100 - EGP 200',
          ),
        ),
        // ... ضيف باقي الـ ServiceCards اللي كانت عندك هنا
      ],
    );
  }
}