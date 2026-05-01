import 'dart:math' as math;

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sakina/features/listings/models/listing_model.dart';

class ListingsRepository {
  final supabase = Supabase.instance.client;

  static const _listingSelect = '''
    *,
    location:location!location_listing_id_fkey (
      address,
      street,
      district,
      city,
      nearby_universities,
      latitude,
      longitude
    )
  ''';

  Future<List<ListingModel>> getAllListings() async {
    final response = await supabase
        .from('property_listings')
        .select(_listingSelect)
        .eq('status', 'available')
        .order('created_at', ascending: false);

    return (response as List).map((e) => ListingModel.fromJson(e)).toList();
  }

  Future<ListingModel> getListingById(String listingId) async {
    final response = await supabase
        .from('property_listings')
        .select(_listingSelect)
        .eq('listing_id', listingId)
        .single();

    return _enrichListing(ListingModel.fromJson(response));
  }

  Future<List<ListingModel>> getListingsByType(String type) async {
    final response = await supabase
        .from('property_listings')
        .select(_listingSelect)
        .eq('property_type', type)
        .eq('status', 'available')
        .order('created_at', ascending: false);

    return (response as List).map((e) => ListingModel.fromJson(e)).toList();
  }

  Future<List<ListingModel>> searchListings(String query) async {
    final response = await supabase
        .from('property_listings')
        .select(_listingSelect)
        .or('title.ilike.%$query%,description.ilike.%$query%')
        .eq('status', 'available')
        .order('created_at', ascending: false);

    return (response as List).map((e) => ListingModel.fromJson(e)).toList();
  }

  Future<void> addReview({
    required String listingId,
    required String landlordId,
    required int rating,
    required String comment,
  }) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('Please log in before writing a review.');
    }

    await supabase.from('review').insert({
      'reviewer_id': user.id,
      'listing_id': listingId,
      if (landlordId.isNotEmpty) 'landlord_id': landlordId,
      'rating': rating,
      'comment': comment.trim(),
      'is_flagged': false,
    });
  }

  Future<ListingModel> _enrichListing(ListingModel listing) async {
    final profile = await _getLandlordProfile(listing.landlordId);
    final reviews = await _getListingReviews(listing.listingId);
    final facilities = await _getPublicFacilities(listing);
    final nearbyServices = await _getNearbyServices(listing);
    final reviewsAverage = _averageRating(reviews);

    return listing.copyWith(
      landlordProfile: profile ?? LandlordProfile.fallback(listing.landlordId),
      reviews: reviews,
      averageRating: listing.averageRating ?? reviewsAverage ?? profile?.rating,
      reviewCount: listing.reviewCount > 0
          ? listing.reviewCount
          : reviews.isNotEmpty
              ? reviews.length
              : profile?.reviewCount,
      publicFacilities: facilities,
      nearbyServices: nearbyServices,
    );
  }

  Future<LandlordProfile?> _getLandlordProfile(String? landlordId) async {
    if (landlordId == null || landlordId.isEmpty) return null;

    final user = await _getUserRow(landlordId);

    Map<String, dynamic>? landlord;
    try {
      landlord = await supabase
          .from('landlord')
          .select()
          .eq('landlord_id', landlordId)
          .maybeSingle();
    } catch (_) {
      landlord = null;
    }

    if (user == null && landlord == null) return null;

    return LandlordProfile.fromJson({
      'landlord_id': landlordId,
      if (landlord != null) ...landlord,
      if (user != null) ...user,
    });
  }

  Future<List<ListingReview>> _getListingReviews(String listingId) async {
    if (listingId.isEmpty) return const [];

    final response = await supabase
        .from('review')
        .select()
        .eq('listing_id', listingId)
        .eq('is_flagged', false)
        .order('created_at', ascending: false);

    final reviews = <ListingReview>[];
    for (final row in (response as List).whereType<Map<String, dynamic>>()) {
      final reviewer = await _getUserRow(row['reviewer_id']?.toString());
      reviews.add(ListingReview.fromJson({
        ...row,
        if (reviewer != null) 'reviewer': reviewer,
      }));
    }

    return reviews;
  }

  Future<List<ListingPlace>> _getPublicFacilities(ListingModel listing) async =>
      const [];

  Future<List<ListingPlace>> _getNearbyServices(ListingModel listing) async {
    final latitude = listing.latitude;
    final longitude = listing.longitude;

    final List<dynamic> response;
    if (latitude != null && longitude != null) {
      const radiusDegrees = 0.04;
      response = await supabase
          .from('service')
          .select()
          .eq('is_active', true)
          .eq('is_approved', true)
          .gte('latitude', latitude - radiusDegrees)
          .lte('latitude', latitude + radiusDegrees)
          .gte('longitude', longitude - radiusDegrees)
          .lte('longitude', longitude + radiusDegrees)
          .limit(12);
    } else {
      response = await supabase
          .from('service')
          .select()
          .eq('is_active', true)
          .eq('is_approved', true)
          .limit(6);
    }

    final services = response.whereType<Map<String, dynamic>>().map((row) {
      final serviceLatitude = _nullableDouble(row['latitude']);
      final serviceLongitude = _nullableDouble(row['longitude']);
      final distance = latitude == null ||
              longitude == null ||
              serviceLatitude == null ||
              serviceLongitude == null
          ? null
          : _formatDistance(
              _distanceKm(
                latitude,
                longitude,
                serviceLatitude,
                serviceLongitude,
              ),
            );

      return ListingPlace.fromJson({
        ...row,
        if (distance != null) 'distance': distance,
      });
    }).toList();

    services.sort((a, b) {
      final aDistance = _distanceNumber(a.distance);
      final bDistance = _distanceNumber(b.distance);
      return aDistance.compareTo(bDistance);
    });

    return services.take(6).toList();
  }

  Future<Map<String, dynamic>?> _getUserRow(String? userId) async {
    if (userId == null || userId.isEmpty) return null;

    try {
      return await supabase
          .from('users')
          .select()
          .eq('user_id', userId)
          .maybeSingle();
    } catch (_) {
      return null;
    }
  }

  double? _averageRating(List<ListingReview> reviews) {
    if (reviews.isEmpty) return null;
    final total = reviews.fold<double>(0, (sum, review) => sum + review.rating);
    return total / reviews.length;
  }

  double _distanceKm(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    const earthRadiusKm = 6371.0;
    final dLat = _degreesToRadians(endLatitude - startLatitude);
    final dLon = _degreesToRadians(endLongitude - startLongitude);
    final startLat = _degreesToRadians(startLatitude);
    final endLat = _degreesToRadians(endLatitude);

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(startLat) *
            math.cos(endLat) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadiusKm * c;
  }

  double _degreesToRadians(double degrees) => degrees * math.pi / 180;

  String _formatDistance(double distanceKm) {
    if (distanceKm < 1) return '${(distanceKm * 1000).round()}m away';
    return '${distanceKm.toStringAsFixed(1)}km away';
  }

  double _distanceNumber(String? distance) {
    if (distance == null) return double.maxFinite;
    final value = double.tryParse(distance.split(RegExp(r'[a-zA-Z]')).first);
    if (value == null) return double.maxFinite;
    return distance.contains('km') ? value * 1000 : value;
  }

  double? _nullableDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
