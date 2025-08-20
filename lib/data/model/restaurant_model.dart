import 'package:equatable/equatable.dart';
import '../../domain/entities/restaurant.dart';

class RestaurantModel extends Restaurant {
  const RestaurantModel({
    required super.id,
    required super.name,
    required super.image,
    required super.cuisine,
    required super.rating,
    required super.deliveryTime,
    required super.deliveryFee,
    required super.categories,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      cuisine: json['cuisine'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      deliveryTime: json['deliveryTime'] ?? 0,
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 0.0,
      categories: List<String>.from(json['categories'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'cuisine': cuisine,
      'rating': rating,
      'deliveryTime': deliveryTime,
      'deliveryFee': deliveryFee,
      'categories': categories,
    };
  }

  RestaurantModel copyWith({
    String? id,
    String? name,
    String? image,
    String? cuisine,
    double? rating,
    int? deliveryTime,
    double? deliveryFee,
    List<String>? categories,
  }) {
    return RestaurantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      cuisine: cuisine ?? this.cuisine,
      rating: rating ?? this.rating,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      categories: categories ?? this.categories,
    );
  }
}

