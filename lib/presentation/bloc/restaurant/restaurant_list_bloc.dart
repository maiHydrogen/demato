import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/model/restaurant_model.dart';
import '../../../data/datasources/remote/mock_data_source.dart';

// Events
abstract class RestaurantListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadRestaurants extends RestaurantListEvent {}

class SearchRestaurants extends RestaurantListEvent {
  final String query;

  SearchRestaurants({required this.query});

  @override
  List<Object?> get props => [query];
}

// States
abstract class RestaurantListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RestaurantListInitial extends RestaurantListState {}

class RestaurantListLoading extends RestaurantListState {}

class RestaurantListLoaded extends RestaurantListState {
  final List<RestaurantModel> restaurants;
  final List<RestaurantModel> filteredRestaurants;

  RestaurantListLoaded({
    required this.restaurants,
    required this.filteredRestaurants,
  });

  @override
  List<Object?> get props => [restaurants, filteredRestaurants];
}

class RestaurantListError extends RestaurantListState {
  final String message;

  RestaurantListError({required this.message});

  @override
  List<Object?> get props => [message];
}

// BLoC
class RestaurantListBloc extends Bloc<RestaurantListEvent, RestaurantListState> {
  RestaurantListBloc() : super(RestaurantListInitial()) {
    on<LoadRestaurants>(_onLoadRestaurants);
    on<SearchRestaurants>(_onSearchRestaurants);
  }

  Future<void> _onLoadRestaurants(
      LoadRestaurants event,
      Emitter<RestaurantListState> emit,
      ) async {
    emit(RestaurantListLoading());

    try {
      await Future.delayed(Duration(seconds: 1)); // Simulate network delay
      final restaurants = MockDataSource.getRestaurants();
      emit(RestaurantListLoaded(
        restaurants: restaurants,
        filteredRestaurants: restaurants,
      ));
    } catch (e) {
      emit(RestaurantListError(message: e.toString()));
    }
  }

  Future<void> _onSearchRestaurants(
      SearchRestaurants event,
      Emitter<RestaurantListState> emit,
      ) async {
    if (state is RestaurantListLoaded) {
      final currentState = state as RestaurantListLoaded;

      if (event.query.isEmpty) {
        emit(RestaurantListLoaded(
          restaurants: currentState.restaurants,
          filteredRestaurants: currentState.restaurants,
        ));
      } else {
        final filteredRestaurants = currentState.restaurants
            .where((restaurant) =>
        restaurant.name.toLowerCase().contains(event.query.toLowerCase()) ||
            restaurant.cuisine.toLowerCase().contains(event.query.toLowerCase()))
            .toList();

        emit(RestaurantListLoaded(
          restaurants: currentState.restaurants,
          filteredRestaurants: filteredRestaurants,
        ));
      }
    }
  }
}
