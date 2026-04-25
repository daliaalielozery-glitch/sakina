import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakina/features/listings/bloc/listings_event.dart';
import 'package:sakina/features/listings/bloc/listings_state.dart';
import 'package:sakina/features/listings/repository/listings_repository.dart';

class ListingsBloc extends Bloc<ListingsEvent, ListingsState> {
  final ListingsRepository repository;

  ListingsBloc(this.repository) : super(ListingsInitial()) {
    on<LoadListings>(_onLoadListings);
    on<LoadListingsByType>(_onLoadByType);
    on<SearchListings>(_onSearch);
  }

  Future<void> _onLoadListings(
    LoadListings event,
    Emitter<ListingsState> emit,
  ) async {
    emit(ListingsLoading());
    try {
      final listings = await repository.getAllListings();
      emit(ListingsLoaded(listings));
    } catch (e) {
      emit(ListingsError(e.toString()));
    }
  }

  Future<void> _onLoadByType(
    LoadListingsByType event,
    Emitter<ListingsState> emit,
  ) async {
    emit(ListingsLoading());
    try {
      final listings = await repository.getListingsByType(event.type);
      emit(ListingsLoaded(listings));
    } catch (e) {
      emit(ListingsError(e.toString()));
    }
  }

  Future<void> _onSearch(
    SearchListings event,
    Emitter<ListingsState> emit,
  ) async {
    emit(ListingsLoading());
    try {
      final listings = await repository.searchListings(event.query);
      emit(ListingsLoaded(listings));
    } catch (e) {
      emit(ListingsError(e.toString()));
    }
  }
}
