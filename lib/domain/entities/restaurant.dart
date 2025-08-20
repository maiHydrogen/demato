import 'package:equatable/equatable.dart';

class Restaurant extends Equatable {
  final String id;
  final String name;
  final String image;
  final String cuisine;
  final double rating;
  final int deliveryTime;
  final double deliveryFee;
  final List<String> categories;

  const Restaurant({
    required this.id,
    required this.name,
    required this.image,
    required this.cuisine,
    required this.rating,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.categories,
  });

  @override
  List<Object?> get props => [id, name, image, cuisine, rating, deliveryTime, deliveryFee];
}
