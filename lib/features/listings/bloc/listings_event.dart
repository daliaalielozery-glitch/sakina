abstract class ListingsEvent {}

class LoadListings extends ListingsEvent {}

class LoadListingsByType extends ListingsEvent {
  final String type;
  LoadListingsByType(this.type);
}

class SearchListings extends ListingsEvent {
  final String query;
  SearchListings(this.query);
}
