import 'package:sakina/features/listings/models/listing_model.dart';

abstract class ListingsState {}

class ListingsInitial extends ListingsState {}

class ListingsLoading extends ListingsState {}

class ListingsLoaded extends ListingsState {
  final List<ListingModel> listings;
  ListingsLoaded(this.listings);
}

class ListingsError extends ListingsState {
  final String message;
  ListingsError(this.message);
}
