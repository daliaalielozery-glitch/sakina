import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sakina/features/listings/models/listing_model.dart';

class ListingsRepository {
  final supabase = Supabase.instance.client;

  Future<List<ListingModel>> getAllListings() async {
    final response = await supabase
        .from('property_listings')
        .select()
        .eq('status', 'available')
        .order('created_at', ascending: false);

    return (response as List).map((e) => ListingModel.fromJson(e)).toList();
  }

  Future<List<ListingModel>> getListingsByType(String type) async {
    final response = await supabase
        .from('property_listings')
        .select()
        .eq('property_type', type)
        .eq('status', 'available')
        .order('created_at', ascending: false);

    return (response as List).map((e) => ListingModel.fromJson(e)).toList();
  }

  Future<List<ListingModel>> searchListings(String query) async {
    final response = await supabase
        .from('property_listings')
        .select()
        .or('title.ilike.%$query%,description.ilike.%$query%')
        .eq('status', 'available')
        .order('created_at', ascending: false);

    return (response as List).map((e) => ListingModel.fromJson(e)).toList();
  }
}
