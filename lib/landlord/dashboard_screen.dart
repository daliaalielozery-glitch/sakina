import 'package:flutter/material.dart';
import 'add_listing_screen.dart';
import 'listing_details_screen.dart';
import 'host_profile_screen.dart';

class Listing {
  final String title;
  final String location;
  final String price;
  final String beds;
  final String tag;
  final String imageUrl;

  const Listing({
    required this.title,
    required this.location,
    required this.price,
    required this.beds,
    required this.tag,
    required this.imageUrl,
  });
}

class HostStats {
  final int totalListings;
  final int activeTenants;
  final int pendingRequests;

  const HostStats({
    required this.totalListings,
    required this.activeTenants,
    required this.pendingRequests,
  });
}

final HostStats dummyStats = const HostStats(
  totalListings: 12,
  activeTenants: 28,
  pendingRequests: 5,
);

final List<Listing> dummyListings = const [
  Listing(
    title: "The Maadi Garden Suite",
    location: "Street 9, Maadi, Cairo",
    price: "14,500",
    beds: "2/3 beds occupied",
    tag: "Available",
    imageUrl:
        "https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=600",
  ),
  Listing(
    title: "Zamalek Heritage Loft",
    location: "Ismail Mohamed St, Zamalek",
    price: "22,000",
    beds: "0/2 beds occupied",
    tag: "Available",
    imageUrl: "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=600",
  ),
  Listing(
    title: "New Cairo Studio",
    location: "5th Settlement",
    price: "9,800",
    beds: "1/1 beds occupied",
    tag: "FULLY BOOKED",
    imageUrl:
        "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=600",
  ),
];

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE6),

      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A0F0A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Khaled",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Manrope",
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.notifications_none),
                ],
              ),
            ),

            // GREETING
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "WELCOME BACK",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        letterSpacing: 1,
                        fontFamily: "Manrope",
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Good morning,\nkhaled.",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Manrope",
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // STATS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: const [
                  Expanded(
                    child: StatCard(
                      icon: Icons.home_work_outlined,
                      number: "12",
                      label: "Total Listings",
                      bg: Colors.white,
                      textColor: Color(0xFF1A0F0A),
                      iconColor: Color(0xFF1A0F0A),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      icon: Icons.group_outlined,
                      number: "28",
                      label: "Active Tenants",
                      bg: Color(0xFF1A0F0A),
                      textColor: Colors.white,
                      iconColor: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      icon: Icons.assignment_outlined,
                      number: "05",
                      label: "Pending Requests",
                      bg: Color(0xFFEDE8E0),
                      textColor: Color(0xFF1A0F0A),
                      iconColor: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // TITLE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "My Listings",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Manrope",
                        ),
                      ),
                      SizedBox(height: 4),
                      SizedBox(
                        height: 3,
                        width: 40,
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: Color(0xFF1A0F0A)),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Text(
                    "Manage all →",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      fontFamily: "Manrope",
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // LISTINGS
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: dummyListings.map((listing) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ListingCard(
                      title: listing.title,
                      location: listing.location,
                      price: listing.price,
                      beds: listing.beds,
                      tag: listing.tag,
                      imageUrl: listing.imageUrl,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),

      // FLOATING BUTTON
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1A0F0A),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddListingScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      // BOTTOM NAV
      bottomNavigationBar: Container(
        height: 70,
        decoration: const BoxDecoration(
          color: Color(0xFF1A0F0A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NavItem(Icons.grid_view, "DASHBOARD", active: true),
            NavItem(Icons.chat_bubble_outline, "MESSAGES", active: false),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HostProfileScreen()),
                );
              },
              child: NavItem(Icons.person_outline, "PROFILE", active: false),
            ),
          ],
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final IconData icon;
  final String number;
  final String label;
  final Color bg;
  final Color textColor;
  final Color iconColor;

  const StatCard({
    super.key,
    required this.icon,
    required this.number,
    required this.label,
    required this.bg,
    required this.textColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(height: 10),
          Text(
            number,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: "Manrope",
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontFamily: "Manrope",
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class ListingCard extends StatelessWidget {
  final String title, location, price, beds, tag, imageUrl;

  const ListingCard({
    super.key,
    required this.title,
    required this.location,
    required this.price,
    required this.beds,
    required this.tag,
    this.imageUrl = "",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 160,
                        color: const Color(0xFFE0D8CC),
                        child: const Center(child: Icon(Icons.image, size: 40)),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 160,
                        color: const Color(0xFFE0D8CC),
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    },
                  )
                : Container(
                    height: 160,
                    color: const Color(0xFFE0D8CC),
                    child: const Center(child: Icon(Icons.image, size: 40)),
                  ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          fontFamily: "Manrope",
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        location,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontFamily: "Manrope",
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            beds,
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: "Manrope",
                            ),
                          ),
                          if (tag.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE0D8CC),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                tag,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontFamily: "Manrope",
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A0F0A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "EGP $price",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: "Manrope",
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ListingDetailsScreen(
                      title: title,
                      location: location,
                      price: price,
                      beds: beds,
                      tag: tag,
                    ),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A0F0A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "View Details →",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontFamily: "Manrope",
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const NavItem(this.icon, this.label, {super.key, this.active = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontFamily: "Manrope",
          ),
        ),
      ],
    );
  }
}
