import 'package:equatable/equatable.dart';
import '../../domain/entities/order.dart';
import 'cart_item_model.dart';
import 'menu_item_model.dart';
import 'restaurant_model.dart';
import 'package:equatable/equatable.dart';

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  ready,
  pickedUp,
  delivered,
  cancelled
}

class OrderModel extends Equatable {
  final String id;
  final String userId;
  final RestaurantModel restaurant;
  final List<CartItemModel> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final OrderStatus status;
  final DateTime createdAt;
  final String? deliveryAddress;

  const OrderModel({
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

  OrderModel copyWith({
    String? id,
    String? userId,
    RestaurantModel? restaurant,
    List<CartItemModel>? items,
    double? subtotal,
    double? deliveryFee,
    double? total,
    OrderStatus? status,
    DateTime? createdAt,
    String? deliveryAddress,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      restaurant: restaurant ?? this.restaurant,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      total: total ?? this.total,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
    );
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      restaurant: RestaurantModel.fromJson(json['restaurant']),
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => CartItemModel.fromJson(item))
          .toList() ?? [],
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      status: OrderStatus.values.firstWhere(
            (e) => e.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      deliveryAddress: json['deliveryAddress'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'restaurant': restaurant.toJson(),
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'total': total,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'deliveryAddress': deliveryAddress,
    };
  }
}
