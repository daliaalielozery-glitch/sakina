class PropertyImage {
  final String imageId;
  final String listingId;
  final String imageUrl;
  final bool is360Tour;

  PropertyImage({
    required this.imageId,
    required this.listingId,
    required this.imageUrl,
    required this.is360Tour,
  });

  factory PropertyImage.fromJson(Map<String, dynamic> json) {
    return PropertyImage(
      imageId: json['image_id'],
      listingId: json['listing_id'],
      imageUrl: json['image_url'],
      is360Tour: json['is_360_tour'] ?? false,
    );
  }
}

class PropertyLocation {
  final String address;
  final String district;
  final String city;
  final String nearbyUniversities;

  PropertyLocation({
    required this.address,
    required this.district,
    required this.city,
    required this.nearbyUniversities,
  });

  factory PropertyLocation.fromJson(Map<String, dynamic> json) {
    return PropertyLocation(
      address: json['address'] ?? '',
      district: json['district'] ?? '',
      city: json['city'] ?? '',
      nearbyUniversities: json['nearby_universities'] ?? '',
    );
  }
}

class ListingModel {
  final String listingId;
  final String landlordId;
  final String title;
  final String description;
  final double rentPrice;
  final String status;
  final String propertyType;
  final int availableRooms;
  final bool has360Tour;
  final DateTime createdAt;
  final List<PropertyImage> images;
  final PropertyLocation? location;

  ListingModel({
    required this.listingId,
    required this.landlordId,
    required this.title,
    required this.description,
    required this.rentPrice,
    required this.status,
    required this.propertyType,
    required this.availableRooms,
    required this.has360Tour,
    required this.createdAt,
    this.images = const [],
    this.location,
  });

  String? get coverImage => images.isNotEmpty ? images.first.imageUrl : null;

  String get locationDisplay {
    if (location == null) return '';
    final parts = [
      location!.district,
      location!.city,
    ].where((e) => e.isNotEmpty).toList();
    return parts.join(', ');
  }

  factory ListingModel.fromJson(Map<String, dynamic> json) {
    final imagesList = (json['property_images'] as List? ?? [])
        .map((e) => PropertyImage.fromJson(e))
        .toList();

    PropertyLocation? locationData;
    if (json['location'] != null) {
      final loc = json['location'];
      if (loc is List && loc.isNotEmpty) {
        locationData = PropertyLocation.fromJson(loc[0]);
      } else if (loc is Map<String, dynamic>) {
        locationData = PropertyLocation.fromJson(loc);
      }
    }

    return ListingModel(
      listingId: json['listing_id'],
      landlordId: json['landlord_id'],
      title: json['title'],
      description: json['description'] ?? '',
      rentPrice: (json['rent_price'] as num).toDouble(),
      status: json['status'] ?? 'available',
      propertyType: json['property_type'] ?? '',
      availableRooms: json['available_rooms'] ?? 0,
      has360Tour: json['has_360_tour'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      images: imagesList,
      location: locationData,
    );
  }
}
