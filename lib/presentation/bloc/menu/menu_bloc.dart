import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/model/menu_item_model.dart';
import '../../../data/datasources/remote/mock_data_source.dart';

// Events
abstract class MenuEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadMenu extends MenuEvent {
  final String restaurantId;

  LoadMenu({required this.restaurantId});

  @override
  List<Object?> get props => [restaurantId];
}

// States
abstract class MenuState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MenuInitial extends MenuState {}

class MenuLoading extends MenuState {}

class MenuLoaded extends MenuState {
  final List<MenuItemModel> menuItems;
  final String restaurantId;

  MenuLoaded({required this.menuItems, required this.restaurantId});

  @override
  List<Object?> get props => [menuItems, restaurantId];
}

class MenuError extends MenuState {
  final String message;

  MenuError({required this.message});

  @override
  List<Object?> get props => [message];
}

// BLoC
class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc() : super(MenuInitial()) {
    on<LoadMenu>(_onLoadMenu);
  }

  Future<void> _onLoadMenu(LoadMenu event, Emitter<MenuState> emit) async {
    emit(MenuLoading());

    try {
      await Future.delayed(Duration(seconds: 1)); // Simulate network delay
      final menuItems = MockDataSource.getMenuItems(event.restaurantId);
      emit(MenuLoaded(menuItems: menuItems, restaurantId: event.restaurantId));
    } catch (e) {
      emit(MenuError(message: e.toString()));
    }
  }
}
