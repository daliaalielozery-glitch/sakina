import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina/features/local_services/ui/quick_wash_laundry_details_screen.dart';
import 'package:sakina/features/local_services/ui/widgets/service_card.dart';
import 'package:sakina/features/local_services/ui/widgets/special_offer_banner.dart';

class AllServicesContent extends StatelessWidget {
  const AllServicesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const QuickWashLaundryDetailsScreen()),
          ),
          child: ServiceCard(
            title: 'local_services.quickwash_laundry'.tr(),
            description: 'local_services.quickwash_desc'.tr(),
            rating: '4.8',
            distance: '300m ${'local_services.away'.tr()}',
            imageUrl: 'https://placehold.co/342x192/png',
          ),
        ),
        ServiceCard(
          title: 'local_services.heritage_kitchen'.tr(),
          description: 'local_services.heritage_desc'.tr(),
          rating: '4.9',
          distance: '1.2km ${'local_services.away'.tr()}',
          imageUrl: 'https://placehold.co/342x192/png',
        ),
        ServiceCard(
          title: 'local_services.profix_maintenance'.tr(),
          description: 'local_services.profix_desc'.tr(),
          rating: '4.6',
          distance: '800m ${'local_services.away'.tr()}',
          imageUrl: 'https://placehold.co/342x192/png',
          tag: 'local_services.request_quote'.tr(),
        ),
        SizedBox(height: 32.h),
        const SpecialOfferBanner(),
      ],
    );
  }
}