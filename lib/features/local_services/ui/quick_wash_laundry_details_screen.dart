import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina/core/widgets/custom_app_bar.dart';
import 'package:sakina/core/widgets/bottom_bar.dart';
import 'widgets/info_card.dart';
import 'widgets/details_service_item.dart';
import 'widgets/details_hero_header.dart';

class QuickWashLaundryDetailsScreen extends StatelessWidget {
  const QuickWashLaundryDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F6),
      appBar: const Myappbar(showBackButton: true, showProfile: false, title: 'QuickWash Laundry'),
      extendBodyBehindAppBar: true,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        onTap: (index) {/* Navigation logic */},
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const DetailsHeroHeader(
              imageUrl: 'https://placehold.co/390x397',
              title: 'QuickWash Laundry',
              location: 'Heliopolis, Cairo',
              rating: '4.9',
            ),
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(),
                  SizedBox(height: 32.h),
                  _buildSectionTitle('Services Offered'),
                  const DetailsServiceItem(title: 'Premium Wash', description: 'Deep clean', icon: Icons.local_laundry_service_outlined),
                  const DetailsServiceItem(title: 'Steam Iron', description: 'Professional finish', icon: Icons.iron_outlined),
                  const DetailsServiceItem(title: 'Eco Care', description: 'Organic detergents', icon: Icons.eco_outlined, tag: 'ECO'),
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
    return Row(
      children: [
        const Expanded(child: InfoCard(label: 'DELIVERY', value: '30 min', icon: Icons.timer_outlined, backgroundColor: Color(0xFFF5F3F0), textColor: Color(0xFF120A00))),
        SizedBox(width: 15.w),
        const Expanded(child: InfoCard(label: 'STARTING AT', value: 'EGP 45', icon: Icons.payments_outlined, backgroundColor: Color(0xFF2C2005), textColor: Color(0xFFF7E0B6), labelColor: Color(0xFFDAC49B))),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Text(title, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700)),
    );
  }

  Widget _buildCTAButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2C2005),
        minimumSize: Size(double.infinity, 68.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26.r)),
      ),
      child: const Text('CHOOSE SERVICE', style: TextStyle(color: Color(0xFFF7E0B6))),
    );
  }
}