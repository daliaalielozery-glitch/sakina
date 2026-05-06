import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina/core/widgets/custom_app_bar.dart';
import 'package:sakina/core/widgets/bottom_bar.dart';
import 'package:sakina/features/local_services/repository/services_repository.dart';
import 'package:sakina/features/local_services/ui/widgets/details_hero_header.dart';
import 'package:sakina/features/local_services/ui/widgets/details_service_item.dart';
import 'package:sakina/features/local_services/ui/widgets/info_card.dart';

class ServiceDetailsScreen extends StatelessWidget {
  final ServiceData service;
  const ServiceDetailsScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F6),
      appBar: Myappbar(
        showBackButton: true,
        showProfile: false,
        title: service.name,
      ),
      extendBodyBehindAppBar: true,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ButtomNavBarScreen(initialIndex: index),
            ),
          );
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DetailsHeroHeader(
              imageUrl: service.imageUrl?.isNotEmpty == true
                  ? service.imageUrl!
                  : 'https://placehold.co/390x397',
              title: service.name,
              location: service.location ?? service.distance ?? 'Cairo, Egypt',
              rating: service.rating.toStringAsFixed(1),
            ),
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(),
                  SizedBox(height: 32.h),
                  _buildDescription(),
                  SizedBox(height: 32.h),
                  _buildSectionTitle('Services Offered'),
                  ..._buildServiceItems(),
                  SizedBox(height: 32.h),
                  _buildCTAButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow() {
    final isLaundry = service.category == 'laundry';
    final isMaintenance = service.category == 'maintenance';

    return Row(
      children: [
        Expanded(
          child: InfoCard(
            label: isLaundry ? 'DELIVERY' : isMaintenance ? 'RESPONSE' : 'SERVICE',
            value: service.deliveryTime ?? (isLaundry ? '30 min' : isMaintenance ? 'Same day' : 'Daily'),
            icon: isLaundry
                ? Icons.timer_outlined
                : isMaintenance
                    ? Icons.build_outlined
                    : Icons.restaurant_outlined,
            backgroundColor: const Color(0xFFF5F3F0),
            textColor: const Color(0xFF120A00),
          ),
        ),
        SizedBox(width: 15.w),
        Expanded(
          child: InfoCard(
            label: 'STARTING AT',
            value: service.priceFrom ?? 'EGP --',
            icon: Icons.payments_outlined,
            backgroundColor: const Color(0xFF2C2005),
            textColor: const Color(0xFFF7E0B6),
            labelColor: const Color(0xFFDAC49B),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About',
          style: TextStyle(
            fontSize: 20.sp,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w700,
            color: const Color(0xFF120A00),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          service.description,
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: 'Manrope',
            color: const Color(0xFF4C463C),
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20.sp,
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w700,
          color: const Color(0xFF120A00),
        ),
      ),
    );
  }

  List<Widget> _buildServiceItems() {
    switch (service.category) {
      case 'laundry':
        return [
          const DetailsServiceItem(title: 'Premium Wash', description: 'Deep clean for all fabrics', icon: Icons.local_laundry_service_outlined),
          const DetailsServiceItem(title: 'Steam Iron', description: 'Professional finish', icon: Icons.iron_outlined),
          const DetailsServiceItem(title: 'Eco Care', description: 'Organic detergents', icon: Icons.eco_outlined, tag: 'ECO'),
        ];
      case 'food':
        return [
          const DetailsServiceItem(title: 'Dine In', description: 'Eat at our location', icon: Icons.restaurant_outlined),
          const DetailsServiceItem(title: 'Takeaway', description: 'Order and pick up', icon: Icons.takeout_dining_outlined),
          const DetailsServiceItem(title: 'Delivery', description: 'Delivered to your door', icon: Icons.delivery_dining_outlined, tag: 'FAST'),
        ];
      case 'maintenance':
        return [
          const DetailsServiceItem(title: 'Inspection', description: 'Full property inspection', icon: Icons.search_outlined),
          const DetailsServiceItem(title: 'Repair', description: 'Fix any issue fast', icon: Icons.build_outlined),
          const DetailsServiceItem(title: 'Emergency', description: '24/7 emergency support', icon: Icons.emergency_outlined, tag: '24/7'),
        ];
      default:
        return [
          DetailsServiceItem(title: service.name, description: service.description, icon: Icons.star_outline),
        ];
    }
  }

  Widget _buildCTAButton() {
    final label = service.category == 'maintenance'
        ? 'REQUEST QUOTE'
        : service.category == 'food'
            ? 'ORDER NOW'
            : 'BOOK SERVICE';

    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2C2005),
        minimumSize: Size(double.infinity, 68.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26.r)),
        elevation: 0,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: const Color(0xFFF7E0B6),
          fontSize: 14.sp,
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
      ),
    );
  }
}