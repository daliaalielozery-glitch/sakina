class ListingModel {
  final String listingId;
  final String title;
  final String description;
  final double rentPrice;
  final String status;
  final String propertyType;
  final int availableRooms;
  final bool has360Tour;
  final String? imageUrl;
  final String? district;
  final String? city;
  final String? nearbyUniversities;

  ListingModel({
    required this.listingId,
    required this.title,
    required this.description,
    required this.rentPrice,
    required this.status,
    required this.propertyType,
    required this.availableRooms,
    required this.has360Tour,
    this.imageUrl,
    this.district,
    this.city,
    this.nearbyUniversities,
  });

  String? get coverImage => imageUrl;

  String get locationDisplay {
    final parts =
        [district, city].where((e) => e != null && e.isNotEmpty).toList();
    return parts.join(', ');
  }

  factory ListingModel.fromJson(Map<String, dynamic> json) {
    return ListingModel(
      listingId: json['listing_id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      rentPrice: (json['rent_price'] as num).toDouble(),
      status: json['status'] ?? 'available',
      propertyType: json['property_type'] ?? '',
      availableRooms: json['available_rooms'] ?? 0,
      has360Tour: json['has_360_tour'] ?? false,
      imageUrl: json['image_url'],
      district: null,
      city: null,
      nearbyUniversities: null,
    );
  }
}
