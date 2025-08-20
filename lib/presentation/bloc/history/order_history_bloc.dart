import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/datasources/remote/mock_data_source.dart';
import '../../../data/model/order_model.dart';

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

// BLoC
class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  OrderHistoryBloc() : super(OrderHistoryInitial()) {
    on<LoadOrderHistory>(_onLoadOrderHistory);
  }

  Future<void> _onLoadOrderHistory(
      LoadOrderHistory event,
      Emitter<OrderHistoryState> emit,
      ) async {
    emit(OrderHistoryLoading());

    try {
      await Future.delayed(Duration(seconds: 1)); // Simulate network delay
      final orders = MockDataSource.getMockOrders(event.userId);
      emit(OrderHistoryLoaded(orders: orders));
    } catch (e) {
      emit(OrderHistoryError(message: e.toString()));
    }
  }
}
