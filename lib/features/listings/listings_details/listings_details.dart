import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sakina/core/theme/app_colors.dart';
import 'package:sakina/features/listings/listings_details/widgets/facilities_card.dart';
import 'package:sakina/features/listings/listings_details/widgets/hero_section.dart';
import 'package:sakina/features/listings/listings_details/widgets/listing_app_bar.dart';
import 'package:sakina/features/listings/listings_details/widgets/location_listing.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Room Detail',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5EFE6),
      ),
      home: const RoomDetailScreen(),
    );
  }
}

class RoomDetailScreen extends StatelessWidget {
  const RoomDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      extendBodyBehindAppBar: true,
      appBar: const ListingAppbar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero Image Section ──
            HeroSection(),
            const SizedBox(height: 80),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Info Card ──
                  _InfoCard(),
                  const SizedBox(height: 28),

                  // ── Sakina Match ──
                  Row(
                    children: const [
                      Icon(Icons.auto_awesome,
                          size: 24, color: Color(0xFF1A1A1A)),
                      SizedBox(width: 6),
                      Text(
                        'Sakina Match',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w700,
                          height: 1.33,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // ── Match Cards ──
                  _MatchCard(
                    icon: Icons.school_outlined,
                    title: 'Academic Proximity',
                    description:
                        "Only a 5-minute walk to Cairo University's main gate. Save 45 minutes of daily commute compared to other listings.",
                    badge: '98% Match for Students',
                  ),
                  const SizedBox(height: 12),
                  _MatchCard(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'Budget Fit',
                    description:
                        '12% below the average for Zamalek student housing.',
                    badge: null,
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),

            FacilitiesCard(),
            LocationMapWidget(),
            EssentialComfortsCard()
          ],
        ),
      ),
    );
  }
}



// ─────────────────────────────────────────
// Info Card
// ─────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.only(top: 50),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge + location
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  // color: const Color(0xFFF5EFE6),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'PREMIUM SUITE',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w700,
                      height: 1.50,
                      letterSpacing: 0.50),
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.location_on_outlined,
                  size: 14, color: Colors.black),
              const Text(
                'Zamalek, Cairo',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w400,
                  height: 1.54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Title
          const Text(
            'The Nile Serenity\nStudio',
            style: TextStyle(
              color: Colors.black,
              fontSize: 32,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
              height: 1.41,
              letterSpacing: -0.90,
            ),
          ),
          const SizedBox(height: 10),

          // Description
          const Text(
            'A curated living experience designed for focused academics and modern comfort. Located in the heart of Cairo\'s diplomatic district.',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w400,
              height: 1.83,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Match Card
// ─────────────────────────────────────────
class _MatchCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? badge;

  const _MatchCard({
    required this.icon,
    required this.title,
    required this.description,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black, width: 1.5),
      ),
      child: Column(
        children: [
          // Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              // color: const Color(0xFFF5EFE6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF1A1A1A),
              size: 30,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),

          // Title
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w700,
              height: 1.40,
            ),
          ),
          const SizedBox(height: 8),

          // Description
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w400,
              height: 1.63,
            ),
          ),

          // Badge
          if (badge != null) ...[
            // const SizedBox(height: 12),
            const Divider(color: Color(0xFFEEE8DE)),
            // const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.verified, size: 14, color: Color(0xFF4CAF50)),
                const SizedBox(width: 5),
                Text(
                  badge!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w700,
                    height: 1.43,
                    color: Color(0xFF4CAF50),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
