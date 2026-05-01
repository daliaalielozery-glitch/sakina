import 'package:flutter/material.dart';
import 'package:sakina/core/theme/app_colors.dart';
import 'package:sakina/features/listings/listings_details/widgets/community_voice_widget.dart';
import 'package:sakina/features/listings/listings_details/widgets/facilities_card.dart';
import 'package:sakina/features/listings/listings_details/widgets/hero_section.dart';
import 'package:sakina/features/listings/listings_details/widgets/listing_app_bar.dart';
import 'package:sakina/features/listings/listings_details/widgets/listing_bottom_bar.dart';
import 'package:sakina/features/listings/listings_details/widgets/location_listing.dart';
import 'package:sakina/features/listings/models/listing_model.dart';
import 'package:sakina/features/listings/repository/listings_repository.dart';

class RoomDetailScreen extends StatefulWidget {
  final ListingModel listing;

  const RoomDetailScreen({
    super.key,
    required this.listing,
  });

  @override
  State<RoomDetailScreen> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  final _repository = ListingsRepository();
  late Future<ListingModel>? _listingFuture;

  @override
  void initState() {
    super.initState();
    _listingFuture = widget.listing.listingId.isEmpty
        ? null
        : _repository.getListingById(widget.listing.listingId);
  }

  @override
  Widget build(BuildContext context) {
    final future = _listingFuture;
    if (future == null) return _buildScaffold(widget.listing);

    return FutureBuilder<ListingModel>(
      future: future,
      initialData: widget.listing,
      builder: (context, snapshot) {
        return _buildScaffold(
          snapshot.data ?? widget.listing,
          isRefreshing: snapshot.connectionState == ConnectionState.waiting,
          refreshError: snapshot.hasError ? snapshot.error.toString() : null,
        );
      },
    );
  }

  Widget _buildScaffold(
    ListingModel listing, {
    bool isRefreshing = false,
    String? refreshError,
  }) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      extendBodyBehindAppBar: true,
      appBar: const ListingAppbar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeroSection(
                  listing: listing,
                  onViewProfile: () => _showLandlordProfile(listing),
                  onView360: () => _show360Tour(listing),
                ),
                const SizedBox(height: 80),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _InfoCard(listing: listing),
                      const SizedBox(height: 28),
                      _SakinaMatchSection(listing: listing),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
                FacilitiesCard(listing: listing),
                LocationMapWidget(listing: listing),
                EssentialComfortsCard(listing: listing),
                CommunityVoiceWidget(
                  listing: listing,
                  onSubmitReview: (rating, comment) =>
                      _submitReview(listing, rating, comment),
                ),
                ListingBottomBar(),
              ],
            ),
          ),
          if (isRefreshing)
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(minHeight: 2),
            ),
          if (refreshError != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: _RefreshErrorBanner(message: refreshError),
            ),
        ],
      ),
    );
  }

  void _showLandlordProfile(ListingModel listing) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFF0EBE0),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => _LandlordProfileSheet(listing: listing),
    );
  }

  void _show360Tour(ListingModel listing) {
    final message = listing.has360Experience
        ? '360 view is available for this listing.'
        : '360 view button is ready. The host has not uploaded a 360 tour yet.';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _submitReview(
    ListingModel listing,
    int rating,
    String comment,
  ) async {
    if (listing.listingId.isEmpty) {
      throw Exception('Listing id is missing.');
    }

    await _repository.addReview(
      listingId: listing.listingId,
      landlordId: listing.landlordId ?? '',
      rating: rating,
      comment: comment,
    );

    if (!mounted) return;
    setState(() {
      _listingFuture = _repository.getListingById(listing.listingId);
    });
  }
}

class _InfoCard extends StatelessWidget {
  final ListingModel listing;

  const _InfoCard({required this.listing});

  @override
  Widget build(BuildContext context) {
    final location = listing.address?.isNotEmpty == true
        ? listing.address!
        : listing.locationDisplay;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  listing.propertyTypeDisplay.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w700,
                    height: 1.50,
                    letterSpacing: 0.50,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.location_on_outlined,
                size: 14,
                color: Colors.black,
              ),
              Expanded(
                child: Text(
                  location.isNotEmpty ? location : 'Location not available',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w400,
                    height: 1.54,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            listing.title.isNotEmpty ? listing.title : 'Untitled listing',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 32,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
              height: 1.41,
              letterSpacing: -0.90,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            listing.description.isNotEmpty
                ? listing.description
                : 'No description has been added for this listing yet.',
            style: const TextStyle(
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

class _SakinaMatchSection extends StatelessWidget {
  final ListingModel listing;

  const _SakinaMatchSection({required this.listing});

  @override
  Widget build(BuildContext context) {
    final university = listing.nearbyUniversities;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.auto_awesome, size: 24, color: Color(0xFF1A1A1A)),
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
        _MatchCard(
          icon: Icons.school_outlined,
          title: 'Academic Proximity',
          description: university?.isNotEmpty == true
              ? 'Close to $university, based on the location added by the host.'
              : 'University proximity will appear once the host adds it.',
          badge: university?.isNotEmpty == true ? 'Student friendly' : null,
        ),
        const SizedBox(height: 12),
        _MatchCard(
          icon: Icons.account_balance_wallet_outlined,
          title: 'Budget Fit',
          description:
              '${listing.priceDisplay} per month for a ${listing.propertyTypeDisplay.toLowerCase()}.',
          badge: listing.status == 'available' ? 'Available now' : null,
        ),
      ],
    );
  }
}

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
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black, width: 1.5),
      ),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
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
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w700,
              height: 1.40,
            ),
          ),
          const SizedBox(height: 8),
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
          if (badge != null) ...[
            const Divider(color: Color(0xFFEEE8DE)),
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

class _RefreshErrorBanner extends StatelessWidget {
  final String message;

  const _RefreshErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.16),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Text(
          'Showing saved preview. Could not refresh listing: $message',
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            height: 1.35,
          ),
        ),
      ),
    );
  }
}

class _LandlordProfileSheet extends StatelessWidget {
  final ListingModel listing;

  const _LandlordProfileSheet({required this.listing});

  @override
  Widget build(BuildContext context) {
    final profile =
        listing.landlordProfile ?? LandlordProfile.fallback(listing.landlordId);
    final avatarUrl = profile.avatarUrl;
    final rating = profile.rating ?? listing.ratingValue;
    final reviewCount = profile.reviewCount > 0
        ? profile.reviewCount
        : listing.resolvedReviewCount;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD8D0C0),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 38,
                  backgroundColor: AppColors.primaryBeig,
                  backgroundImage:
                      avatarUrl == null ? null : NetworkImage(avatarUrl),
                  child: avatarUrl == null
                      ? const Icon(
                          Icons.person_rounded,
                          color: Colors.black54,
                          size: 34,
                        )
                      : null,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF120A00),
                          fontSize: 24,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Color(0xFFF5A623),
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            rating > 0
                                ? '${rating.toStringAsFixed(1)} host rating'
                                : 'New host',
                            style: const TextStyle(
                              color: Color(0xFF4C463C),
                              fontSize: 13,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _HostChip(
                  icon: Icons.home_work_outlined,
                  label: listing.propertyTypeDisplay,
                ),
                _HostChip(
                  icon: Icons.reviews_outlined,
                  label: '$reviewCount reviews',
                ),
                if (profile.location?.isNotEmpty == true)
                  _HostChip(
                    icon: Icons.location_on_outlined,
                    label: profile.location!,
                  ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'About Host',
              style: TextStyle(
                color: Color(0xFF120A00),
                fontSize: 16,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              profile.about?.isNotEmpty == true
                  ? profile.about!
                  : 'This host has not added a public bio yet.',
              style: const TextStyle(
                color: Color(0xFF4C463C),
                fontSize: 14,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w400,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A1A1A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Close profile',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HostChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HostChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryBeig,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF120A00), size: 15),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF120A00),
              fontSize: 12,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
