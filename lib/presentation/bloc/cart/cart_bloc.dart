import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/model/cart_item_model.dart';
import '../../../data/model/menu_item_model.dart';

// Events
abstract class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddToCart extends CartEvent {
  final MenuItemModel menuItem;
  final int quantity;

  AddToCart({required this.menuItem, this.quantity = 1});

  @override
  List<Object?> get props => [menuItem, quantity];
}

class RemoveFromCart extends CartEvent {
  final String menuItemId;

  RemoveFromCart({required this.menuItemId});

  @override
  List<Object?> get props => [menuItemId];
}

class UpdateCartItemQuantity extends CartEvent {
  final String menuItemId;
  final int quantity;

  UpdateCartItemQuantity({required this.menuItemId, required this.quantity});

  @override
  List<Object?> get props => [menuItemId, quantity];
}

class ClearCart extends CartEvent {}

class LoadCart extends CartEvent {}

// States
abstract class CartState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItemModel> items;
  final double subtotal;
  final double deliveryFee;
  final double total;

  CartLoaded({
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
  });

  @override
  List<Object?> get props => [items, subtotal, deliveryFee, total];
}

class CartError extends CartState {
  final String message;

  CartError({required this.message});

  @override
  List<Object?> get props => [message];
}

// BLoC
class CartBloc extends Bloc<CartEvent, CartState> {
  static const double defaultDeliveryFee = 2.99;

  CartBloc() : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateCartItemQuantity>(_onUpdateCartItemQuantity);
    on<ClearCart>(_onClearCart);
  }

  void _onLoadCart(LoadCart event, Emitter<CartState> emit) {
    // For now, start with empty cart
    emit(CartLoaded(
      items: [],
      subtotal: 0.0,
      deliveryFee: 0.0,
      total: 0.0,
    ));
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      final existingItems = List<CartItemModel>.from(currentState.items);

      // Check if item already exists
      final existingIndex = existingItems.indexWhere(
            (item) => item.menuItem.id == event.menuItem.id,
      );

      if (existingIndex >= 0) {
        // Update quantity of existing item
        final existingItem = existingItems[existingIndex];
        existingItems[existingIndex] = existingItem.copyWith(
          quantity: existingItem.quantity + event.quantity,
        );
      } else {
        // Add new item
        existingItems.add(
          CartItemModel.fromMenuItem(event.menuItem, event.quantity),
        );
      }

      _emitCartLoaded(emit, existingItems);
    }
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      final existingItems = List<CartItemModel>.from(currentState.items);

      existingItems.removeWhere(
            (item) => item.menuItem.id == event.menuItemId,
      );

      _emitCartLoaded(emit, existingItems);
    }
  }

  void _onUpdateCartItemQuantity(
      UpdateCartItemQuantity event,
      Emitter<CartState> emit,
      ) {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      final existingItems = List<CartItemModel>.from(currentState.items);

      if (event.quantity <= 0) {
        existingItems.removeWhere(
              (item) => item.menuItem.id == event.menuItemId,
        );
      } else {
        final existingIndex = existingItems.indexWhere(
              (item) => item.menuItem.id == event.menuItemId,
        );

        if (existingIndex >= 0) {
          final existingItem = existingItems[existingIndex];
          existingItems[existingIndex] = existingItem.copyWith(
            quantity: event.quantity,
          );
        }
      }

      _emitCartLoaded(emit, existingItems);
    }
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    emit(CartLoaded(
      items: [],
      subtotal: 0.0,
      deliveryFee: 0.0,
      total: 0.0,
    ));
  }

  void _emitCartLoaded(Emitter<CartState> emit, List<CartItemModel> items) {
    final subtotal = items.fold<double>(
      0.0,
          (sum, item) => sum + item.totalPrice,
    );

    final deliveryFee = items.isEmpty ? 0.0 : defaultDeliveryFee;
    final total = subtotal + deliveryFee;

    emit(CartLoaded(
      items: items,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      total: total,
    ));
  }
}
