import 'package:equatable/equatable.dart';
import 'menu_item.dart';
import 'restaurant.dart';

class CartItem extends Equatable {
  final MenuItem menuItem;
  final int quantity;

  const CartItem({
    required this.menuItem,
    required this.quantity,
  });

  double get totalPrice => menuItem.price * quantity;

  @override
  List<Object?> get props => [menuItem, quantity];
}

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  ready,
  pickedUp,
  delivered,
  cancelled
}

class Order extends Equatable {
  final String id;
  final String userId;
  final Restaurant restaurant;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final OrderStatus status;
  final DateTime createdAt;
  final String? deliveryAddress;

  const Order({
    required this.id,
    required this.userId,
    required this.restaurant,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.status,
    required this.createdAt,
    this.deliveryAddress,
  });

  @override
  List<Object?> get props => [
    id, userId, restaurant, items, subtotal,
    deliveryFee, total, status, createdAt, deliveryAddress
  ];
}
