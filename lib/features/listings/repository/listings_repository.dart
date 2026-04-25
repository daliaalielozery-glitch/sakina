import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sakina/features/listings/models/listing_model.dart';

class ListingsRepository {
  final supabase = Supabase.instance.client;

  Future<List<ListingModel>> getAllListings() async {
    final response = await supabase
        .from('property_listings')
        .select('''
          *,
          property_image ( image_id, listing_id, image_url, is_360_tour, uploaded_at ),
          location ( location_id, listing_id, latitude, longitude, address, street, district, city, nearby_universities )
        ''')
        .eq('status', 'available')
        .order('created_at', ascending: false);

    return (response as List).map((e) => ListingModel.fromJson(e)).toList();
  }

  Future<List<ListingModel>> getListingsByType(String type) async {
    final response = await supabase
        .from('property_listings')
        .select('''
          *,
          property_image ( image_id, listing_id, image_url, is_360_tour, uploaded_at ),
          location ( location_id, listing_id, latitude, longitude, address, street, district, city, nearby_universities )
        ''')
        .eq('property_type', type)
        .eq('status', 'available')
        .order('created_at', ascending: false);

    return (response as List).map((e) => ListingModel.fromJson(e)).toList();
  }

  Future<List<ListingModel>> searchListings(String query) async {
    final response = await supabase
        .from('property_listings')
        .select('''
          *,
          property_image ( image_id, listing_id, image_url, is_360_tour, uploaded_at ),
          location ( location_id, listing_id, latitude, longitude, address, street, district, city, nearby_universities )
        ''')
        .or('title.ilike.%$query%,description.ilike.%$query%')
        .eq('status', 'available')
        .order('created_at', ascending: false);

    return (response as List).map((e) => ListingModel.fromJson(e)).toList();
  }
}
