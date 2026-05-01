// ─────────────────────────────────────────
// Hero Section
// ─────────────────────────────────────────
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sakina/core/theme/app_colors.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => HeroSectionState();
}

class HeroSectionState extends State<HeroSection> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> _images = [
    'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800',
    'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800',
    'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Room photo carousel
        Container(
          height: 260,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFF8AACB8),
          ),
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _images.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    _images[index],
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(Icons.bed, size: 60, color: Colors.white30),
                    ),
                  );
                },
              ),
              // Dots indicator
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _images.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Starting at + price
        Positioned(
          top: 75,
          left: 16,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.35),
                    width: 1.2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'STARTING AT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w400,
                        height: 1.33,
                        letterSpacing: 1.20,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'EGP 3,500',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w700,
                        height: 1.40,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // 360 view badge
        Positioned(
          top: 75,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Color(0XFF2C2005),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '360 view',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w700,
                height: 2,
              ),
            ),
          ),
        ),

        // Avatar + name overlapping the image bottom
        Positioned(
          bottom: -65,
          left: 16,
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: NetworkImage(
                      'https://mockmind-api.uifaces.co/content/human/208.jpg',
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBeig,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                        child: Text(
                          'view profile',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w400,
                            height: 1.67,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              const Text(
                'Lalila Ahmed',
                style: TextStyle(
                  color: Color(0xFF120A00),
                  fontSize: 19,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w800,
                  height: 1.47,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
