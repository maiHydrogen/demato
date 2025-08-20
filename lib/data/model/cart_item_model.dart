import 'package:equatable/equatable.dart';
import '../../domain/entities/order.dart';
import 'menu_item_model.dart';

class CartItemModel extends CartItem {
  const CartItemModel({
    required MenuItemModel menuItem,
    required super.quantity,
  }) : super(menuItem: menuItem);

  MenuItemModel get menuItemModel => menuItem as MenuItemModel;

  @override
  double get totalPrice => menuItem.price * quantity;

  CartItemModel copyWith({
    MenuItemModel? menuItem,
    int? quantity,
  }) {
    return CartItemModel(
      menuItem: menuItem ?? menuItemModel,
      quantity: quantity ?? this.quantity,
    );
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      menuItem: MenuItemModel.fromJson(json['menuItem']),
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menuItem': menuItemModel.toJson(),
      'quantity': quantity,
    };
  }

  // Helper method to create from MenuItem and quantity
  factory CartItemModel.fromMenuItem(MenuItemModel menuItem, int quantity) {
    return CartItemModel(
      menuItem: menuItem,
      quantity: quantity,
    );
  }

  @override
  String toString() {
    return 'CartItemModel(menuItem: ${menuItem.name}, quantity: $quantity, totalPrice: $totalPrice)';
  }
}
