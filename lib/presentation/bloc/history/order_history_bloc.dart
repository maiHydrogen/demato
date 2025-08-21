import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/model/order_model.dart';
import '../../../data/datasources/local/order_storage.dart';

// Events
abstract class OrderHistoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadOrderHistory extends OrderHistoryEvent {
  final String userId;

  LoadOrderHistory({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class RefreshOrderHistory extends OrderHistoryEvent {
  final String userId;

  RefreshOrderHistory({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class ClearOrderHistory extends OrderHistoryEvent {}

// States
abstract class OrderHistoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OrderHistoryInitial extends OrderHistoryState {}

class OrderHistoryLoading extends OrderHistoryState {}

class OrderHistoryLoaded extends OrderHistoryState {
  final List<OrderModel> orders;

  OrderHistoryLoaded({required this.orders});

  @override
  List<Object?> get props => [orders];
}

class OrderHistoryError extends OrderHistoryState {
  final String message;

  OrderHistoryError({required this.message});

  @override
  List<Object?> get props => [message];
}

class OrderHistoryCleared extends OrderHistoryState {}

// BLoC
class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  final OrderStorage _orderStorage = OrderStorage.instance;

  OrderHistoryBloc() : super(OrderHistoryInitial()) {
    on<LoadOrderHistory>(_onLoadOrderHistory);
    on<RefreshOrderHistory>(_onRefreshOrderHistory);
    on<ClearOrderHistory>(_onClearOrderHistory);
  }

  Future<void> _onLoadOrderHistory(
      LoadOrderHistory event,
      Emitter<OrderHistoryState> emit,
      ) async {
    emit(OrderHistoryLoading());

    try {
      await Future.delayed(Duration(milliseconds: 500)); // Small delay for UX
      final orders = await _orderStorage.getOrdersByUserId(event.userId);
      emit(OrderHistoryLoaded(orders: orders));
    } catch (e) {
      emit(OrderHistoryError(message: 'Failed to load order history: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshOrderHistory(
      RefreshOrderHistory event,
      Emitter<OrderHistoryState> emit,
      ) async {
    // Don't show loading for refresh
    try {
      final orders = await _orderStorage.getOrdersByUserId(event.userId);
      emit(OrderHistoryLoaded(orders: orders));
    } catch (e) {
      emit(OrderHistoryError(message: 'Failed to refresh order history: ${e.toString()}'));
    }
  }

  Future<void> _onClearOrderHistory(
      ClearOrderHistory event,
      Emitter<OrderHistoryState> emit,
      ) async {
    try {
      await _orderStorage.clearOrders();
      emit(OrderHistoryCleared());
    } catch (e) {
      emit(OrderHistoryError(message: 'Failed to clear order history: ${e.toString()}'));
    }
  }
}
