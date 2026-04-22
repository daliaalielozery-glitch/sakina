import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Property App',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         fontFamily: 'Poppins',
//         scaffoldBackgroundColor: const Color(0xFFF2EDE8),
//       ),
//       home: const PropertyListingScreen(),
//     );
//   }
// }

class PropertyListingScreen extends StatefulWidget {
  const PropertyListingScreen({super.key});

  @override
  State<PropertyListingScreen> createState() => _PropertyListingScreenState();
}

class _PropertyListingScreenState extends State<PropertyListingScreen> {
  int _selectedTab = 0;

  final List<Map<String, dynamic>> featuredProperties = [
    {
      'name': 'Park Avenue',
      'subtitle': 'Modern Enclave',
      'price': '12,000/Month',
      'rating': 4.8,
      'image': 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=400',
      'isFavorite': false,
    },
    {
      'name': 'Max Apart',
      'subtitle': 'Modern Flat',
      'price': '10,500/Month',
      'rating': 4.5,
      'image': 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=400',
      'isFavorite': false,
    },
  ];

  final List<Map<String, dynamic>> nearbyProperties = [
    {
      'name': 'Max Apart',
      'price': 'EGP 3,000',
      'image': 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=200',
      'isFavorite': false,
    },
    {
      'name': 'Delux Encl',
      'price': 'EGP 2,500',
      'image': 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=200',
      'isFavorite': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      // backgroundColor: const Color(0xFFF2EDE8),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tab Bar
              _buildTabBar(),

              const SizedBox(height: 20),

              // Featured Properties Horizontal List
              _buildFeaturedList(),

              const SizedBox(height: 28),

              // Property Nearby Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Property Nearby',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Nearby Properties List
              _buildNearbyList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    final tabs = ['Apartment', 'Room'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = _selectedTab == index;
          return Padding(
            padding: EdgeInsets.only(right: index < tabs.length - 1 ? 12 : 0),
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : [],
                ),
                child: Text(
                  tabs[index],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.grey.shade800 : Colors.grey.shade500,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildFeaturedList() {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20, right: 8),
        itemCount: featuredProperties.length,
        itemBuilder: (context, index) {
          final property = featuredProperties[index];
          return _buildFeaturedCard(property, index);
        },
      ),
    );
  }

  Widget _buildFeaturedCard(Map<String, dynamic> property, int index) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 230,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.01),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image
              Image.network(
                property['image'],
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.image, size: 60, color: Colors.white),
                ),
              ),

              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.65),
                    ],
                    stops: const [0.4, 1.0],
                  ),
                ),
              ),

              // Price Tag (top right)
              Positioned(
                top: 14,
                right: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    property['price'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              // Bottom Info
              Positioned(
                left: 14,
                right: 14,
                bottom: 14,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.star, color: Color(0xFFFFC107), size: 14),
                              const SizedBox(width: 4),
                              Text(
                                property['rating'].toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            property['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            property['subtitle'],
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.75),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Favorite button
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          property['isFavorite'] = !property['isFavorite'];
                        });
                      },
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          property['isFavorite']
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: property['isFavorite']
                              ? Colors.red
                              : Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNearbyList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: nearbyProperties.length,
      itemBuilder: (context, index) {
        return _buildNearbyCard(nearbyProperties[index]);
      },
    );
  }

  Widget _buildNearbyCard(Map<String, dynamic> property) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              property['image'],
              width: 70,
              height: 65,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: 70,
                height: 65,
                color: Colors.grey.shade200,
                child: const Icon(Icons.image, color: Colors.grey),
              ),
            ),
          ),

          const SizedBox(width: 14),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property['name'],
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  property['price'],
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // Favorite Icon
          GestureDetector(
            onTap: () {
              setState(() {
                property['isFavorite'] = !property['isFavorite'];
              });
            },
            child: Icon(
              property['isFavorite'] ? Icons.favorite : Icons.favorite_border,
              color: property['isFavorite'] ? Colors.red : Colors.grey.shade400,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}