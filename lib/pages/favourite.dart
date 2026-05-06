import 'package:flutter/material.dart';
import 'package:sakina/core/theme/app_colors.dart';
import 'package:sakina/features/listings/listings_details/listings_details.dart';
import 'package:sakina/features/listings/models/listing_model.dart';
import 'package:sakina/features/listings/repository/listings_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  final _supabase = Supabase.instance.client;
  final _repo = ListingsRepository();

  List<ListingModel> _listings = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadFavourites();
  }

  Future<void> _loadFavourites() async {
    setState(() => _loading = true);
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) { setState(() => _loading = false); return; }

      final favs = await _supabase
          .from('favourites')
          .select('listing_id')
          .eq('user_id', userId);

      final ids = (favs as List)
          .whereType<Map<String, dynamic>>()
          .map((f) => f['listing_id']?.toString() ?? '')
          .where((id) => id.isNotEmpty)
          .toList();

      final listings = <ListingModel>[];
      for (final id in ids) {
        try {
          final listing = await _repo.getListingById(id);
          listings.add(listing);
        } catch (_) {}
      }

      if (mounted) setState(() { _listings = listings; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _removeFavourite(String listingId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;
    await _supabase.from('favourites')
        .delete()
        .eq('user_id', userId)
        .eq('listing_id', listingId);
    setState(() => _listings.removeWhere((l) => l.listingId == listingId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CURATED COLLECTION',
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 2.4,
                        color: Colors.brown.shade400,
                        fontFamily: 'Georgia',
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Saved & Favorites',
                      style: TextStyle(
                        color: Color(0xFF120A00),
                        fontSize: 32,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w400,
                        height: 1.20,
                        letterSpacing: -1.60,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            if (_loading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_listings.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite_border, size: 64, color: Colors.brown.shade200),
                      const SizedBox(height: 16),
                      Text(
                        'No saved listings yet',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Manrope',
                          color: Colors.brown.shade400,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap the heart on any listing to save it here',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Manrope',
                          color: Colors.brown.shade300,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final listing = _listings[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: _ListingCard(
                          listing: listing,
                          onRemove: () => _removeFavourite(listing.listingId),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RoomDetailScreen(listing: listing),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: _listings.length,
                  ),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: _CompareFavoritesPromo(),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}

class _ListingCard extends StatelessWidget {
  final ListingModel listing;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  const _ListingCard({
    required this.listing,
    required this.onRemove,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = listing.galleryImages.isNotEmpty
        ? listing.galleryImages.first
        : null;
    final location = listing.address?.isNotEmpty == true
        ? listing.address!
        : listing.locationDisplay;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.brown.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    color: const Color(0xFF8AACB8),
                    child: imageUrl != null
                        ? Image.network(imageUrl, fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.home, size: 64, color: Colors.white30))
                        : const Icon(Icons.home, size: 64, color: Colors.white30),
                  ),
                ),
                Positioned(
                  top: 12, right: 12,
                  child: GestureDetector(
                    onTap: onRemove,
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 8)],
                      ),
                      child: const Icon(Icons.favorite, size: 18, color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              listing.title.isNotEmpty ? listing.title : 'Untitled',
                              style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700,
                                color: Color(0xFF2C2218),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.location_on_outlined, size: 12, color: Colors.brown.shade300),
                                const SizedBox(width: 2),
                                Expanded(
                                  child: Text(
                                    location.isNotEmpty ? location : 'Cairo, Egypt',
                                    maxLines: 1, overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 12, color: Colors.brown.shade400),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            listing.priceDisplay,
                            style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w800,
                              color: Color(0xFF2C2218),
                            ),
                          ),
                          Text(
                            'per month',
                            style: TextStyle(fontSize: 10, color: Colors.brown.shade400),
                          ),
                        ],
                      ),
                    ],
                  ),

                  if (listing.propertyType.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8, runSpacing: 6,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3EDE4),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFD4C4A8), width: 0.8),
                          ),
                          child: Text(
                            listing.propertyTypeDisplay,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF7A6550)),
                          ),
                        ),
                        if (listing.status == 'available')
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E8),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFF8BC48A), width: 0.8),
                            ),
                            child: const Text(
                              'Available',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF4A8A49)),
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompareFavoritesPromo extends StatelessWidget {
  const _CompareFavoritesPromo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Container(
            padding: const EdgeInsets.only(left: 20),
            decoration: const BoxDecoration(
              border: Border(left: BorderSide(color: Color(0xFFF7E0B6), width: 3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '"Finding the right space is the first step toward building your sanctuary. These are the homes you\'ve felt a connection with."',
                  style: TextStyle(
                    color: Color(0xFF2C2005), fontSize: 24,
                    fontFamily: 'Manrope', fontWeight: FontWeight.w400, height: 1.30,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(width: 40, height: 2, color: const Color(0xFFDAC49B)),
                    const SizedBox(width: 12),
                    const Text('EDITORIAL NOTE',
                        style: TextStyle(color: Color(0xFF4C463C), fontSize: 12,
                            fontFamily: 'Manrope', fontWeight: FontWeight.w400, letterSpacing: 1.20)),
                  ],
                ),
              ],
            ),
          ),
        ),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF28200B),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Compare your favorites',
                  style: TextStyle(color: Colors.white, fontSize: 20,
                      fontFamily: 'Manrope', fontWeight: FontWeight.w400, height: 1.40)),
              const SizedBox(height: 12),
              const Text(
                'Analyze compatibility scores and utility splits side-by-side to make the final decision.',
                style: TextStyle(color: Color(0xFF9A8762), fontSize: 14,
                    fontFamily: 'Manrope', fontWeight: FontWeight.w400, height: 1.63),
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF7E0B6),
                  foregroundColor: const Color(0xFF2C2218),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                ),
                child: const Text('Enter Compare Mode',
                    style: TextStyle(color: Color(0xFF120A00), fontSize: 14,
                        fontFamily: 'Manrope', fontWeight: FontWeight.w400, height: 1.25)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}