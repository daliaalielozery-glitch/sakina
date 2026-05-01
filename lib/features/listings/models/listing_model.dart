class ListingModel {
  final String listingId;
  final String? landlordId;
  final String title;
  final String description;
  final double rentPrice;
  final String status;
  final String propertyType;
  final int availableRooms;
  final bool has360Tour;
  final String? tour360Url;
  final String? imageUrl;
  final List<String> imageUrls;
  final String? address;
  final String? street;
  final String? district;
  final String? city;
  final String? nearbyUniversities;
  final double? latitude;
  final double? longitude;
  final List<String> amenities;
  final LandlordProfile? landlordProfile;
  final double? averageRating;
  final int reviewCount;
  final List<ListingReview> reviews;
  final List<ListingPlace> publicFacilities;
  final List<ListingPlace> nearbyServices;

  ListingModel({
    required this.listingId,
    this.landlordId,
    required this.title,
    required this.description,
    required this.rentPrice,
    required this.status,
    required this.propertyType,
    required this.availableRooms,
    required this.has360Tour,
    this.tour360Url,
    this.imageUrl,
    this.imageUrls = const [],
    this.address,
    this.street,
    this.district,
    this.city,
    this.nearbyUniversities,
    this.latitude,
    this.longitude,
    this.amenities = const [],
    this.landlordProfile,
    this.averageRating,
    this.reviewCount = 0,
    this.reviews = const [],
    this.publicFacilities = const [],
    this.nearbyServices = const [],
  });

  String? get coverImage {
    final image = imageUrl?.trim();
    if (image == null || image.isEmpty) return null;
    return image;
  }

  String get priceDisplay => 'EGP ${rentPrice.toStringAsFixed(0)}';

  String get propertyTypeDisplay {
    if (propertyType.isEmpty) return 'Property';
    return propertyType
        .split('_')
        .where((part) => part.isNotEmpty)
        .map((part) => part[0].toUpperCase() + part.substring(1))
        .join(' ');
  }

  String get roomsDisplay {
    if (availableRooms <= 0) return 'Rooms available';
    return '$availableRooms ${availableRooms == 1 ? 'room' : 'rooms'} available';
  }

  bool get has360Experience {
    final tourUrl = tour360Url?.trim();
    return has360Tour || (tourUrl != null && tourUrl.isNotEmpty);
  }

  double get ratingValue {
    if (averageRating != null && averageRating! > 0) return averageRating!;
    if (reviews.isEmpty) return 0;
    final total = reviews.fold<double>(0, (sum, review) => sum + review.rating);
    return total / reviews.length;
  }

  int get resolvedReviewCount {
    if (reviewCount > 0) return reviewCount;
    return reviews.length;
  }

  List<String> get galleryImages {
    final images = [
      ...imageUrls,
      if (imageUrl != null && imageUrl!.trim().isNotEmpty) imageUrl!,
    ];
    return images.where((image) => image.trim().isNotEmpty).toSet().toList();
  }

  String get locationDisplay {
    final parts = [district, city]
        .where((e) => e != null && e.trim().isNotEmpty)
        .cast<String>()
        .toList();
    return parts.join(', ');
  }

  factory ListingModel.fromJson(Map<String, dynamic> json) {
    final location = _locationFromJson(json['location']);

    return ListingModel(
      listingId: json['listing_id']?.toString() ?? '',
      landlordId: json['landlord_id']?.toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      rentPrice: _toDouble(json['rent_price']),
      status: json['status'] ?? 'available',
      propertyType: json['property_type'] ?? '',
      availableRooms: _toInt(json['available_rooms']),
      has360Tour: json['has_360_tour'] ?? false,
      tour360Url: LandlordProfile._stringOrNull(
        json['tour_360_url'] ?? json['vr_tour_url'] ?? json['panorama_url'],
      ),
      imageUrl: json['image_url'],
      imageUrls: _toStringList(json['image_urls'] ?? json['photos']),
      address: location['address']?.toString() ?? json['address']?.toString(),
      street: location['street']?.toString() ?? json['street']?.toString(),
      district:
          location['district']?.toString() ?? json['district']?.toString(),
      city: location['city']?.toString() ?? json['city']?.toString(),
      nearbyUniversities: location['nearby_universities']?.toString() ??
          json['nearby_universities']?.toString(),
      latitude: _nullableDouble(location['latitude'] ?? json['latitude']),
      longitude: _nullableDouble(location['longitude'] ?? json['longitude']),
      amenities: _toStringList(json['amenities']),
      landlordProfile: LandlordProfile.fromJsonOrNull(
        json['landlord'] ?? json['profile'] ?? json['profiles'],
      ),
      averageRating: _nullableDouble(
        json['average_rating'] ?? json['rating_average'] ?? json['rating'],
      ),
      reviewCount: _toInt(json['review_count'] ?? json['reviews_count']),
      reviews: _toReviewList(json['reviews'] ?? json['listing_reviews']),
      publicFacilities:
          _toPlaceList(json['public_facilities'] ?? json['facilities']),
      nearbyServices:
          _toPlaceList(json['nearby_services'] ?? json['local_services']),
    );
  }

  ListingModel copyWith({
    LandlordProfile? landlordProfile,
    double? averageRating,
    int? reviewCount,
    List<ListingReview>? reviews,
    List<ListingPlace>? publicFacilities,
    List<ListingPlace>? nearbyServices,
  }) {
    return ListingModel(
      listingId: listingId,
      landlordId: landlordId,
      title: title,
      description: description,
      rentPrice: rentPrice,
      status: status,
      propertyType: propertyType,
      availableRooms: availableRooms,
      has360Tour: has360Tour,
      tour360Url: tour360Url,
      imageUrl: imageUrl,
      imageUrls: imageUrls,
      address: address,
      street: street,
      district: district,
      city: city,
      nearbyUniversities: nearbyUniversities,
      latitude: latitude,
      longitude: longitude,
      amenities: amenities,
      landlordProfile: landlordProfile ?? this.landlordProfile,
      averageRating: averageRating ?? this.averageRating,
      reviewCount: reviewCount ?? this.reviewCount,
      reviews: reviews ?? this.reviews,
      publicFacilities: publicFacilities ?? this.publicFacilities,
      nearbyServices: nearbyServices ?? this.nearbyServices,
    );
  }

  static Map<String, dynamic> _locationFromJson(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is List && value.isNotEmpty) {
      final first = value.first;
      if (first is Map<String, dynamic>) return first;
    }
    return const {};
  }

  static List<String> _toStringList(dynamic value) {
    if (value == null) return const [];
    if (value is List) {
      return value
          .where((item) => item != null && item.toString().trim().isNotEmpty)
          .map((item) => item.toString())
          .toList();
    }
    if (value is String && value.trim().isNotEmpty) {
      return value
          .split(',')
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toList();
    }
    return const [];
  }

  static List<ListingReview> _toReviewList(dynamic value) {
    if (value is! List) return const [];
    return value
        .whereType<Map<String, dynamic>>()
        .map(ListingReview.fromJson)
        .toList();
  }

  static List<ListingPlace> _toPlaceList(dynamic value) {
    if (value is! List) return const [];
    return value
        .whereType<Map<String, dynamic>>()
        .map(ListingPlace.fromJson)
        .where((place) => place.name.isNotEmpty)
        .toList();
  }

  static double _toDouble(dynamic value) => _nullableDouble(value) ?? 0;

  static double? _nullableDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }
}

class ListingPlace {
  final String name;
  final String? category;
  final String? distance;
  final String? address;
  final double? rating;

  const ListingPlace({
    required this.name,
    this.category,
    this.distance,
    this.address,
    this.rating,
  });

  factory ListingPlace.fromJson(Map<String, dynamic> json) {
    final name = json['name'] ??
        json['title'] ??
        json['facility_name'] ??
        json['service_name'] ??
        json['place_name'] ??
        '';
    return ListingPlace(
      name: name.toString(),
      category: LandlordProfile._stringOrNull(
        json['category'] ?? json['type'] ?? json['service_type'],
      ),
      distance: LandlordProfile._stringOrNull(
        json['distance'] ?? json['distance_text'] ?? json['walking_time'],
      ),
      address: LandlordProfile._stringOrNull(json['address']),
      rating: ListingModel._nullableDouble(json['rating']),
    );
  }

  String? get subtitle {
    final parts = [
      distance,
      category,
      if (rating != null && rating! > 0) '${rating!.toStringAsFixed(1)} rating',
      address,
    ]
        .where((part) => part != null && part.trim().isNotEmpty)
        .cast<String>()
        .toList();
    if (parts.isEmpty) return null;
    return parts.join(' - ');
  }
}

class LandlordProfile {
  final String id;
  final String name;
  final String? avatarUrl;
  final String? location;
  final String? about;
  final double? rating;
  final int reviewCount;

  const LandlordProfile({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.location,
    this.about,
    this.rating,
    this.reviewCount = 0,
  });

  factory LandlordProfile.fallback(String? landlordId) {
    return LandlordProfile(
      id: landlordId ?? '',
      name: 'Host',
    );
  }

  static LandlordProfile? fromJsonOrNull(dynamic value) {
    if (value is List && value.isNotEmpty) value = value.first;
    if (value is! Map<String, dynamic>) return null;
    return LandlordProfile.fromJson(value);
  }

  factory LandlordProfile.fromJson(Map<String, dynamic> json) {
    final id = json['id'] ??
        json['user_id'] ??
        json['profile_id'] ??
        json['landlord_id'] ??
        '';
    final name = json['full_name'] ??
        json['name'] ??
        json['display_name'] ??
        json['username'] ??
        'Host';
    return LandlordProfile(
      id: id.toString(),
      name: name.toString(),
      avatarUrl: _stringOrNull(
        json['avatar_url'] ??
            json['profile_image'] ??
            json['photo_url'] ??
            json['image_url'],
      ),
      location: _stringOrNull(json['location'] ?? json['city']),
      about: _stringOrNull(json['about'] ?? json['bio'] ?? json['description']),
      rating: ListingModel._nullableDouble(
        json['overall_rating'] ??
            json['rating'] ??
            json['average_rating'] ??
            json['rating_average'],
      ),
      reviewCount: ListingModel._toInt(
        json['review_count'] ?? json['reviews_count'],
      ),
    );
  }

  static String? _stringOrNull(dynamic value) {
    final text = value?.toString().trim();
    if (text == null || text.isEmpty) return null;
    return text;
  }
}

class ListingReview {
  final String reviewerName;
  final String? reviewerAvatarUrl;
  final String tag;
  final String comment;
  final double rating;

  const ListingReview({
    required this.reviewerName,
    this.reviewerAvatarUrl,
    required this.tag,
    required this.comment,
    required this.rating,
  });

  factory ListingReview.fromJson(Map<String, dynamic> json) {
    final reviewer = LandlordProfile.fromJsonOrNull(
      json['reviewer'] ?? json['tenant'] ?? json['profile'] ?? json['profiles'],
    );
    final comment = json['comment'] ??
        json['review'] ??
        json['body'] ??
        json['message'] ??
        '';
    return ListingReview(
      reviewerName:
          reviewer?.name ?? json['reviewer_name']?.toString() ?? 'Student',
      reviewerAvatarUrl: reviewer?.avatarUrl ??
          LandlordProfile._stringOrNull(json['reviewer_avatar_url']),
      tag: json['tag']?.toString() ??
          json['reviewer_tag']?.toString() ??
          'STUDENT REVIEW',
      comment: comment.toString(),
      rating: ListingModel._toDouble(json['rating']),
    );
  }
}
