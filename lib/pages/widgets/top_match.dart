import 'package:flutter/material.dart';
import 'package:sakina/core/theme/app_colors.dart';

class TopMatch extends StatelessWidget {
  const TopMatch({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
                color: AppColors.themeColor,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Top Matches',
                          style: TextStyle(
                            color: Color(0xFF120A00),
                            fontSize: 24,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w400,
                            height: 1.33,
                            letterSpacing: -0.60,
                          ),
                        ),
                        Text(
                          'SEE ALL',
                          style: TextStyle(
                            color: Color(0xFF4C463C),
                            fontSize: 12,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w400,
                            height: 1.33,
                            letterSpacing: 1.20,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Main card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBeig,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Compatibility badge (top right)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF7E0B6),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  '98% COMPATIBILITY',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF7A6F65),
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // Avatar + Name + Tags row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Avatar
                              CircleAvatar(
                                radius: 44,
                                backgroundImage: AssetImage(
                                  'assets/pictures/profile.jpg',
                                ),
                              ),

                              const SizedBox(width: 16),

                              // Name + tags
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Nour El-Din, 21',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1C1C1C),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      _buildTag('QUIET'),
                                      const SizedBox(width: 8),
                                      _buildTag('EARLY BIRD'),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Bio text
                          const Text(
                            'Architecture student at AUC. Loves vinyl records and a clean kitchen.',
                            style: TextStyle(
                              color: Color(0xFF4C463C),
                              fontSize: 14,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w400,
                              height: 1.63,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // View Profile button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1C1C1C),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 0,
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'View Profile',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w400,
                                      height: 1.43,
                                      letterSpacing: 0.35,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward, size: 16),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
  }
}

Widget _buildTag(String label) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: const Color(0xFFEAE8E5),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xFFEAE8E5)),
    ),
    child: Text(
      label,
      style: const TextStyle(
        color: Color(0xFF4C463C),
        fontSize: 10,
        fontFamily: 'Manrope',
        fontWeight: FontWeight.w400,
        height: 1.50,
        letterSpacing: 0.50,
      ),
    ),
  );
}