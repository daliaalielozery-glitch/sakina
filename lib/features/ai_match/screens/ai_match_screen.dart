import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sakina/core/theme/app_colors.dart';
import 'package:sakina/core/widgets/custom_app_bar.dart';

// ─── Models ───────────────────────────────────────────────────────────────────
class PropertyMatch {
  final String listingId;
  final String title;
  final String imageUrl;
  final double rentPrice;
  final String propertyType;
  final int score;
  final List<String> reasons;

  PropertyMatch({
    required this.listingId,
    required this.title,
    required this.imageUrl,
    required this.rentPrice,
    required this.propertyType,
    required this.score,
    required this.reasons,
  });

  factory PropertyMatch.fromJson(Map<String, dynamic> json) {
    final listing = json['listing'] as Map<String, dynamic>;
    return PropertyMatch(
      listingId: listing['listing_id'] ?? '',
      title: listing['title'] ?? '',
      imageUrl: listing['image_url'] ?? '',
      rentPrice: (listing['rent_price'] as num?)?.toDouble() ?? 0,
      propertyType: listing['property_type'] ?? '',
      score: (json['score'] as num?)?.toInt() ?? 0,
      reasons: List<String>.from(json['reasons'] ?? []),
    );
  }
}

class RoommateMatch {
  final String tenantId;
  final String fullName;
  final String avatarUrl;
  final String university;
  final int score;
  final List<String> reasons;
  final Map<String, dynamic> breakdown;

  RoommateMatch({
    required this.tenantId,
    required this.fullName,
    required this.avatarUrl,
    required this.university,
    required this.score,
    required this.reasons,
    required this.breakdown,
  });

  factory RoommateMatch.fromJson(Map<String, dynamic> json) {
    final tenant = json['tenant'] as Map<String, dynamic>;
    return RoommateMatch(
      tenantId: tenant['tenant_id'] ?? '',
      fullName: tenant['full_name'] ?? 'Unknown',
      avatarUrl: tenant['avatar_url'] ?? '',
      university: tenant['university'] ?? '',
      score: (json['score'] as num?)?.toInt() ?? 0,
      reasons: List<String>.from(json['reasons'] ?? []),
      breakdown: json['breakdown'] as Map<String, dynamic>? ?? {},
    );
  }

  List<String> get tags {
    final tags = <String>[];
    if (breakdown['circadian'] != null && (breakdown['circadian'] as num) >= 80) {
      tags.add('Same Sleep Schedule');
    }
    if (breakdown['social'] != null && (breakdown['social'] as num) >= 80) {
      tags.add('Similar Social Style');
    }
    if (breakdown['smoking'] != null && (breakdown['smoking'] as num) >= 90) {
      tags.add('Non-Smoker');
    }
    if (breakdown['studyTime'] != null && (breakdown['studyTime'] as num) >= 80) {
      tags.add('Same Study Hours');
    }
    if (breakdown['cleanliness'] != null && (breakdown['cleanliness'] as num) >= 80) {
      tags.add('Clean & Tidy');
    }
    if (tags.isEmpty) tags.add('Compatible');
    return tags.take(3).toList();
  }
}

// ─── Repository ───────────────────────────────────────────────────────────────
class AiMatchRepository {
  final _supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> fetchMatches({double budget = 15000}) async {
    final session = _supabase.auth.currentSession;
    if (session == null) throw Exception('Not logged in');

    final response = await _supabase.functions.invoke(
      'ai-match',
      body: {'budget': budget},
    );

    if (response.status != 200) {
      throw Exception(response.data?['error'] ?? 'Matching failed');
    }

    return response.data as Map<String, dynamic>;
  }
}

// ─── Screen ───────────────────────────────────────────────────────────────────
class AiMatchScreen extends StatefulWidget {
  const AiMatchScreen({super.key});

  @override
  State<AiMatchScreen> createState() => _AiMatchScreenState();
}

class _AiMatchScreenState extends State<AiMatchScreen> {
  final _repo = AiMatchRepository();
  late Future<Map<String, dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repo.fetchMatches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Myappbar(),
      backgroundColor: AppColors.themeColor,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snap.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                    const SizedBox(height: 12),
                    Text(
                      snap.error.toString().contains('profile')
                          ? 'Please complete your lifestyle survey first!'
                          : 'Could not load matches. Try again.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 16,
                        color: Color(0xFF4C463C),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          setState(() => _future = _repo.fetchMatches()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1C1C1C),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          final data = snap.data!;
          final propertyMatches = (data['property_matches'] as List? ?? [])
              .map((e) => PropertyMatch.fromJson(e))
              .toList();
          final roommateMatches = (data['roommate_matches'] as List? ?? [])
              .map((e) => RoommateMatch.fromJson(e))
              .toList();

          return RefreshIndicator(
            onRefresh: () async =>
                setState(() => _future = _repo.fetchMatches()),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Title ──────────────────────────────────────────────
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
                  const SizedBox(height: 8),
                  Text(
                    '${propertyMatches.length} properties · ${roommateMatches.length} roommates found',
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 14,
                      color: Color(0xFF4C463C),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Top Rooms ──────────────────────────────────────────
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

                  if (propertyMatches.isEmpty)
                    _EmptyState(
                      icon: Icons.home_outlined,
                      message:
                          'No property matches found yet.\nCheck back when more listings are available.',
                    )
                  else
                    ...propertyMatches.map((match) => Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: _RoomCard(match: match),
                        )),

                  const SizedBox(height: 16),

                  // ── Ideal Roommates ────────────────────────────────────
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

                  if (roommateMatches.isEmpty)
                    _EmptyState(
                      icon: Icons.people_outline,
                      message:
                          'No roommate matches yet.\nMore tenants will appear as they join.',
                    )
                  else
                    ...roommateMatches.map((match) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _RoommateCard(match: match),
                        )),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE8E0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: const Color(0xFF888888)),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 14,
              color: Color(0xFF888888),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Room Card ────────────────────────────────────────────────────────────────
class _RoomCard extends StatelessWidget {
  final PropertyMatch match;
  const _RoomCard({required this.match});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              match.imageUrl.isNotEmpty
                  ? Image.network(
                      match.imageUrl,
                      height: 280,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 280,
                        color: const Color(0xFF2C2C2C),
                        child: const Icon(Icons.bed,
                            color: Colors.white24, size: 60),
                      ),
                    )
                  : Container(
                      height: 280,
                      color: const Color(0xFF2C2C2C),
                      child: const Icon(Icons.bed,
                          color: Colors.white24, size: 60),
                    ),

              // Match badge
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7E0B6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.bolt, size: 14, color: Colors.black),
                      const SizedBox(width: 3),
                      Text(
                        '${match.score}% Match',
                        style: const TextStyle(
                          color: Color(0xFF251A02),
                          fontSize: 12,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Price badge
              Positioned(
                bottom: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: ShapeDecoration(
                    color: const Color(0xE5FBF9F6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Monthly Rent',
                        style: TextStyle(
                          color: Color(0xFF4C463C),
                          fontSize: 12,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'EGP ${match.rentPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Color(0xFF120A00),
                          fontSize: 20,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Title & reasons
        const SizedBox(height: 12),
        Text(
          match.title,
          style: const TextStyle(
            color: Color(0xFF120A00),
            fontSize: 20,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        ...match.reasons.map((r) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Icon(
                    r.startsWith('⚠️')
                        ? Icons.warning_amber_rounded
                        : Icons.check_circle_outline,
                    size: 14,
                    color: r.startsWith('⚠️')
                        ? Colors.orange
                        : const Color(0xFF4A7C59),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      r.replaceAll('⚠️ ', ''),
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 13,
                        color: Color(0xFF4C463C),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}

// ─── Roommate Card ────────────────────────────────────────────────────────────
class _RoommateCard extends StatelessWidget {
  final RoommateMatch match;
  const _RoommateCard({required this.match});

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
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: match.avatarUrl.isNotEmpty
                    ? Image.network(
                        match.avatarUrl,
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _avatarFallback(),
                      )
                    : _avatarFallback(),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            match.fullName,
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
                            '${match.score}% MATCH',
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
                      match.university.isNotEmpty
                          ? match.university
                          : 'Student',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: match.tags
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

  Widget _avatarFallback() {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: const Color(0xFFE0D5C5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(Icons.person, color: Colors.grey, size: 36),
    );
  }
}
