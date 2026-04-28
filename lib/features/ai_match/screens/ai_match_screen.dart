import 'package:flutter/material.dart';
import 'package:sakina/core/theme/app_colors.dart';
import 'package:sakina/core/widgets/custom_app_bar.dart';

class AiMatchScreen extends StatelessWidget {

  
  const AiMatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Myappbar(),
      backgroundColor: AppColors.themeColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text(
                'Your Top Matches',
                style: TextStyle(
                  color: Color(0xFF120A00),
                  fontSize: 40,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w800,
                  height: 1.32,
                  letterSpacing: -1.20,
                ),
              ),
              const SizedBox(height: 24),

              // Top Rooms Section
              const Text(
                'Top rooms',
                style: TextStyle(
                  color: Color(0xFF120A00),
                  fontSize: 24,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w500,
                  height: 1.33,
                ),
              ),
              const SizedBox(height: 12),
              _RoomCard(imageUrl: 'https://t3.ftcdn.net/jpg/05/24/28/40/360_F_524284007_oT8vZaLnIu8qP8PYmvCfpo0NNjnTEaYr.jpg',),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    SizedBox(
                      height: 16,
                      width: 12,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 312,
                            child: Text(
                              'Sakan Al-Maadi Studio',
                              style: TextStyle(
                                color: const Color(0xFF120A00),
                                fontSize: 20,
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.w700,
                                height: 1.40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 4,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [],
                          ),
                          SizedBox(
                            height: 24,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on, // تقدري تغيري الايكون
                                  size: 18,
                                  color: Color(0xFF4C463C),
                                ),
                                SizedBox(width: 4), // مسافة بين الايكون والنص
                                Text(
                                  'Degla Maadi, Cairo',
                                  style: TextStyle(
                                    color: Color(0xFF4C463C),
                                    fontSize: 16,
                                    fontFamily: 'Manrope',
                                    fontWeight: FontWeight.w500,
                                    height: 1.50,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Ideal Roommates Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ideal Roommates',
                    style: TextStyle(
                      color: Color(0xFF120A00),
                      fontSize: 24,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                    ),
                  ),
                  Icon(Icons.tune, color: Colors.grey[600], size: 20),
                ],
              ),
              const SizedBox(height: 16),
              _RoommateCard(
                name: 'Omar Mansour',
                subtitle: 'Cairo University',
                matchPercent: '95% MATCH',
                tags: const ['Architecture Student', 'Quiet', 'Early Bird'],
                imageUrl:
                    'https://plus.unsplash.com/premium_photo-1689565611422-b2156cc65e47?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OXx8bWFuJTIwcHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D',
              ),
              const SizedBox(height: 12),
              _RoommateCard(
                name: 'Laila Farid',
                subtitle: 'AUC Student',
                matchPercent: '97% MATCH',
                tags: const ['Art Major', 'Plant Lover', 'Night Owl'],
                imageUrl:
                    'https://plus.unsplash.com/premium_photo-1690407617542-2f210cf20d7e?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8d29tYW4lMjBwcm9maWxlfGVufDB8fDB8fHww',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  final String imageUrl;
  

  const _RoomCard({required this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          // Room image (dark interior placeholder)
          Image.network(
            imageUrl,
            height: 341.33,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 200,
              color: const Color(0xFF2C2C2C),
              child: const Icon(Icons.bed, color: Colors.white24, size: 60),
            ),
          ),

          // Match badge
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Color(0xFFF7E0B6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.bolt, size: 14, color: Colors.black),
                  SizedBox(width: 3),
                  Text(
                    '98% Match',
                    style: TextStyle(
                      color: Color(0xFF251A02),
                      fontSize: 12,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w600,
                      height: 1.33,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Rent info
          Positioned(
            bottom: 12,
            left: 12,
            // right: 0,
            child: Container(
              // backgroundColor: Colors.black.withValues(alpha: 0.5),
              padding: const EdgeInsets.all(14),
              decoration: ShapeDecoration(
                color: const Color(0xE5FBF9F6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 75.91,
                    height: 16,
                    child: Text(
                      'Monthly Rent',
                      style: TextStyle(
                        color: const Color(0xFF4C463C),
                        fontSize: 12,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w500,
                        height: 1.33,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 107.30,
                    height: 28,
                    child: Text(
                      'EGP 2,500',
                      style: TextStyle(
                        color: const Color(0xFF120A00),
                        fontSize: 20,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w700,
                        height: 1.40,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class _RoommateCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final String matchPercent;
  final List<String> tags;
  final String imageUrl;

  const _RoommateCard({
    required this.name,
    required this.subtitle,
    required this.matchPercent,
    required this.tags,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 72,
                    height: 72,
                    color: const Color(0xFFE0D5C5),
                    child: const Icon(Icons.person, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Name, university, match
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5EFE6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            matchPercent,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFA07840),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Tags
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: tags
                          .map((tag) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5EFE6),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  tag,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF5A4A35),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // View profile button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A1A1A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: const Text(
                'View profile',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );

    
  }
}
