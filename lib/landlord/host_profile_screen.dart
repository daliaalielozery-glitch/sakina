import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'edit_profile_screen.dart';
import 'listing_details_screen.dart';

class HostProfileScreen extends StatelessWidget {
  const HostProfileScreen({super.key});

  static const Color bg = Color(0xFFF5F3EF);
  static const Color card = Color(0xFFEEE9DF);
  static const Color softCard = Color(0xFFF0EBE2);
  static const Color brown = Color(0xFF1B1209);
  static const Color muted = Color(0xFF7A746C);
  static const Color border = Color(0xFFE8E1D7);
  static const Color accent = Color(0xFFEFD9A7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    const _TopBell(),
                    const SizedBox(height: 20),
                    const Center(child: _ProfilePhoto()),
                    const SizedBox(height: 18),
                    const Text(
                      'Khaled Ibrahim',
                      style: TextStyle(
                        fontSize: 30,
                        height: 1.0,
                        fontWeight: FontWeight.w800,
                        color: brown,
                        letterSpacing: -1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: const [
                        Icon(
                          Icons.location_on_outlined,
                          size: 15,
                          color: muted,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Cairo, Egypt',
                          style: TextStyle(
                            fontSize: 13,
                            color: muted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(' | ', style: TextStyle(color: Color(0xFFB8B1A7))),
                        SizedBox(width: 10),
                        Text(
                          'Member since 2021',
                          style: TextStyle(
                            fontSize: 13,
                            color: muted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: _ActionButton(
                            title: 'Edit\nProfile',
                            icon: Icons.edit_outlined,
                            filled: true,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const EditProfileScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: _ActionButton(
                            title: 'Contact\nSupport',
                            icon: Icons.headset_mic_outlined,
                            filled: false,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: const [
                        Expanded(
                          child: _StatCard(label: 'PROPERTIES', value: '12'),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            label: 'RESPONSE RATE',
                            value: '98%',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const _RatingCard(),
                    const SizedBox(height: 22),
                    const Text(
                      'About Me',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: brown,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'I specialize in curating high-end living spaces specifically for the modern student in Cairo. My background in architecture allows me to ensure every property balances heritage charm with modern functionality.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.75,
                        color: Color(0xFF59534D),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                      decoration: BoxDecoration(
                        color: softCard,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'HOST BADGES',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF7A746C),
                              letterSpacing: 0.8,
                            ),
                          ),
                          SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _BadgeChip(label: 'Fast Responder'),
                              _BadgeChip(label: 'Identity Verified'),
                              _BadgeChip(label: 'Safe Space Host'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'All\nProperties',
                          style: TextStyle(
                            fontSize: 18,
                            height: 1.0,
                            fontWeight: FontWeight.w800,
                            color: brown,
                          ),
                        ),
                        Text(
                          'View All',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF746A5F),
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const _PropertyCard(
                      title: 'Maadi Garden Suite',
                      location: 'Street 9, Maadi, Cairo',
                      imageUrl:
                          'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=600',
                      price: '14,500',
                      tag: '',
                    ),
                    const SizedBox(height: 12),
                    const _PropertyCard(
                      title: 'Zamalek Heritage Loft',
                      location: 'Ismail Mohamed St, Zamalek',
                      imageUrl:
                          'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=600',
                      price: '22,000',
                      tag: 'Available',
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'Host Ratings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: brown,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _ReviewCard(
                      name: 'Youssef A.',
                      review:
                          '"Khaled is an exceptional host. He truly understands what students need. When my AC stopped working, he had a technician there within two hours."',
                      date: 'SEPT 2023',
                      initials: 'YA',
                      stars: 5,
                    ),
                    const SizedBox(height: 12),
                    _ReviewCard(
                      name: 'Mariam S.',
                      review:
                          '"Great experience staying at the Maadi Suite. The property is exactly as described and Khaled is very professional and easy to communicate with."',
                      date: 'AUG 2023',
                      initials: 'MS',
                      stars: 5,
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _BottomNav(activeIndex: 2),
    );
  }
}

class _TopBell extends StatelessWidget {
  const _TopBell();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: HostProfileScreen.card,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.notifications_outlined,
            color: HostProfileScreen.brown,
            size: 20,
          ),
        ),
      ],
    );
  }
}

class _ProfilePhoto extends StatelessWidget {
  const _ProfilePhoto();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: HostProfileScreen.card,
        shape: BoxShape.circle,
        border: Border.all(color: HostProfileScreen.border, width: 3),
      ),
      child: const Icon(Icons.person, size: 50, color: HostProfileScreen.muted),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool filled;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.title,
    required this.icon,
    required this.filled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: filled ? HostProfileScreen.brown : HostProfileScreen.card,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: filled ? Colors.white : HostProfileScreen.brown,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: filled ? Colors.white : HostProfileScreen.brown,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: HostProfileScreen.card,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: HostProfileScreen.brown,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: HostProfileScreen.muted,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingCard extends StatelessWidget {
  const _RatingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: HostProfileScreen.accent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: HostProfileScreen.card,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.star, color: Color(0xFFD4A017), size: 20),
          ),
          const SizedBox(width: 12),
          const Text(
            '4.9',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: HostProfileScreen.brown,
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeChip extends StatelessWidget {
  final String label;
  const _BadgeChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: HostProfileScreen.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: HostProfileScreen.border),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: HostProfileScreen.brown,
        ),
      ),
    );
  }
}

class _PropertyCard extends StatelessWidget {
  final String title;
  final String location;
  final String imageUrl;
  final String price;
  final String tag;

  const _PropertyCard({
    required this.title,
    required this.location,
    required this.imageUrl,
    required this.price,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ListingDetailsScreen(
              title: title,
              location: location,
              price: price,
              beds: '',
              tag: tag,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: HostProfileScreen.card,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                imageUrl,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 140,
                  color: const Color(0xFFE0D8CC),
                  child: const Center(child: Icon(Icons.image, size: 40)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: HostProfileScreen.brown,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    location,
                    style: const TextStyle(
                      fontSize: 12,
                      color: HostProfileScreen.muted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'EGP $price',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: HostProfileScreen.brown,
                        ),
                      ),
                      if (tag.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: HostProfileScreen.softCard,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: HostProfileScreen.brown,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final String name;
  final String review;
  final String date;
  final String initials;
  final int stars;

  const _ReviewCard({
    required this.name,
    required this.review,
    required this.date,
    required this.initials,
    required this.stars,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: HostProfileScreen.softCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: HostProfileScreen.card,
                  shape: BoxShape.circle,
                  border: Border.all(color: HostProfileScreen.border),
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: HostProfileScreen.brown,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: HostProfileScreen.brown,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          i < stars ? Icons.star : Icons.star_border,
                          size: 12,
                          color: const Color(0xFFD4A017),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 10,
                  color: HostProfileScreen.muted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            review,
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color: Color(0xFF59534D),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int activeIndex;
  const _BottomNav({required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: HostProfileScreen.brown,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const DashboardScreen()),
              (route) => false,
            ),
            child: _NavItem(
              icon: Icons.grid_view,
              label: 'DASHBOARD',
              active: activeIndex == 0,
            ),
          ),
          _NavItem(
            icon: Icons.chat_bubble_outline,
            label: 'MESSAGES',
            active: activeIndex == 1,
          ),
          _NavItem(
            icon: Icons.person,
            label: 'PROFILE',
            active: activeIndex == 2,
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white, size: 22),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            letterSpacing: 0.04,
          ),
        ),
      ],
    );
  }
}
