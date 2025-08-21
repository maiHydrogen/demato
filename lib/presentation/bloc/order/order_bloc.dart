import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import '../../../data/datasources/local/order_storage.dart';
import '../../../data/model/cart_item_model.dart';
import '../../../data/model/order_model.dart';
import '../../../data/model/restaurant_model.dart';

// Events (same as before)
abstract class OrderEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PlaceOrder extends OrderEvent {
  final String userId;
  final RestaurantModel restaurant;
  final List<CartItemModel> cartItems;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String? deliveryAddress;

  PlaceOrder({
    required this.userId,
    required this.restaurant,
    required this.cartItems,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    this.deliveryAddress,
  });

  @override
  List<Object?> get props => [
    userId, restaurant, cartItems, subtotal,
    deliveryFee, total, deliveryAddress
  ];
}

class UpdateOrderStatus extends OrderEvent {
  final String orderId;
  final OrderStatus newStatus;

  UpdateOrderStatus({
    required this.orderId,
    required this.newStatus,
  });

  @override
  List<Object?> get props => [orderId, newStatus];
}

class CancelOrder extends OrderEvent {
  final String orderId;
  final String reason;

  CancelOrder({
    required this.orderId,
    this.reason = 'User cancelled',
  });

  @override
  List<Object?> get props => [orderId, reason];
}

// States (same as before)
abstract class OrderState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}

class OrderPlacing extends OrderState {}

class OrderPlaced extends OrderState {
  final OrderModel order;

  OrderPlaced({required this.order});

  @override
  List<Object?> get props => [order];
}

class OrderStatusUpdated extends OrderState {
  final OrderModel order;

  OrderStatusUpdated({required this.order});

  @override
  List<Object?> get props => [order];
}

class OrderCancelled extends OrderState {
  final String orderId;
  final String reason;

  OrderCancelled({
    required this.orderId,
    required this.reason,
  });

  @override
  List<Object?> get props => [orderId, reason];
}

class OrderError extends OrderState {
  final String message;

  OrderError({required this.message});

  @override
  List<Object?> get props => [message];
}

// BLoC (updated)
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final Uuid _uuid = Uuid();
  final OrderStorage _orderStorage = OrderStorage.instance;

  OrderBloc() : super(OrderInitial()) {
    on<PlaceOrder>(_onPlaceOrder);
    on<UpdateOrderStatus>(_onUpdateOrderStatus);
    on<CancelOrder>(_onCancelOrder);
  }

  Future<void> _onPlaceOrder(
      PlaceOrder event,
      Emitter<OrderState> emit,
      ) async {
    emit(OrderPlacing());

    try {
      // Simulate API call delay
      await Future.delayed(Duration(seconds: 2));

      // Create new order
      final order = OrderModel(
        id: _uuid.v4(),
        userId: event.userId,
        restaurant: event.restaurant,
        items: event.cartItems,
        subtotal: event.subtotal,
        deliveryFee: event.deliveryFee,
        total: event.total,
        status: OrderStatus.confirmed,
        createdAt: DateTime.now(),
        deliveryAddress: event.deliveryAddress ?? 'Default Address',
      );

      // Save order to storage
      await _orderStorage.addOrder(order);

      emit(OrderPlaced(order: order));

    } catch (e) {
      emit(OrderError(message: 'Failed to place order: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateOrderStatus(
      UpdateOrderStatus event,
      Emitter<OrderState> emit,
      ) async {
    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 1));

      // Update order status in storage
      await _orderStorage.updateOrderStatus(event.orderId, event.newStatus);

      // Get updated orders to find the specific order
      // In a real app, you'd fetch the specific order from API/DB
      emit(OrderStatusUpdated(order: OrderModel(
        id: event.orderId,
        userId: 'current_user',
        restaurant: RestaurantModel(
          id: '1', name: 'Sample Restaurant', image: '', cuisine: 'Various',
          rating: 4.0, deliveryTime: 30, deliveryFee: 2.99, categories: [],
        ),
        items: [],
        subtotal: 0.0,
        deliveryFee: 2.99,
        total: 2.99,
        status: event.newStatus,
        createdAt: DateTime.now(),
      )));

    } catch (e) {
      emit(OrderError(message: 'Failed to update order: ${e.toString()}'));
    }
  }

  Future<void> _onCancelOrder(
      CancelOrder event,
      Emitter<OrderState> emit,
      ) async {
    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 1));

      // Update order status to cancelled
      await _orderStorage.updateOrderStatus(event.orderId, OrderStatus.cancelled);

      emit(OrderCancelled(
        orderId: event.orderId,
        reason: event.reason,
      ));

    } catch (e) {
      emit(OrderError(message: 'Failed to cancel order: ${e.toString()}'));
    }
  }
}
