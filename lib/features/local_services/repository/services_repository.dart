import 'package:supabase_flutter/supabase_flutter.dart';

class ServiceData {
  final String id;
  final String name;
  final String description;
  final String category;
  final String? imageUrl;
  final double rating;
  final String? distance;
  final String? location;
  final String? priceFrom;
  final String? deliveryTime;
  final String? subCategory;

  ServiceData({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.imageUrl,
    required this.rating,
    this.distance,
    this.location,
    this.priceFrom,
    this.deliveryTime,
    this.subCategory,
  });

  factory ServiceData.fromJson(Map<String, dynamic> json) {
    return ServiceData(
      id: json['service_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? 'all',
      imageUrl: json['image_url']?.toString(),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      distance: json['distance']?.toString(),
      location: json['location']?.toString(),
      priceFrom: json['price_from']?.toString(),
      deliveryTime: json['delivery_time']?.toString(),
      subCategory: json['sub_category']?.toString(),
    );
  }
}

class ServicesRepository {
  final _supabase = Supabase.instance.client;

  Future<List<ServiceData>> getAllServices() async {
    final response = await _supabase
        .from('service')
        .select()
        .eq('is_active', true)
        .eq('is_approved', true)
        .order('name');
    return (response as List)
        .whereType<Map<String, dynamic>>()
        .map(ServiceData.fromJson)
        .toList();
  }

  Future<List<ServiceData>> getServicesByCategory(String category) async {
    final response = await _supabase
        .from('service')
        .select()
        .eq('is_active', true)
        .eq('is_approved', true)
        .eq('category', category)
        .order('name');
    return (response as List)
        .whereType<Map<String, dynamic>>()
        .map(ServiceData.fromJson)
        .toList();
  }
}