import 'package:flutter/foundation.dart';

enum ServiceCategory { all, laundry, food, maintenance }

class ServiceModel {
  final String title;
  final String description;
  final String rating;
  final String distance;
  final String imageUrl;
  final String? tag;
  final String? priceRange;
  final VoidCallback? onTap;
  final ServiceCategory category;

  ServiceModel({
    required this.title,
    required this.description,
    required this.rating,
    required this.distance,
    required this.imageUrl,
    this.tag,
    this.priceRange,
    this.onTap,
    this.category = ServiceCategory.all,
  });
}