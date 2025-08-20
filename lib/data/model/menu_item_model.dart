import 'package:equatable/equatable.dart';
import '../../domain/entities/menu_item.dart';

class MenuItemModel extends MenuItem {
  const MenuItemModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.image,
    required super.category,
    required super.isVeg,
    super.isAvailable = true,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      image: json['image'] ?? '',
      category: json['category'] ?? '',
      isVeg: json['isVeg'] ?? false,
      isAvailable: json['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'category': category,
      'isVeg': isVeg,
      'isAvailable': isAvailable,
    };
  }

  MenuItemModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? image,
    String? category,
    bool? isVeg,
    bool? isAvailable,
  }) {
    return MenuItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      image: image ?? this.image,
      category: category ?? this.category,
      isVeg: isVeg ?? this.isVeg,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
