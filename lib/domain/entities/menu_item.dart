import 'package:equatable/equatable.dart';

class MenuItem extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final String category;
  final bool isVeg;
  final bool isAvailable;

  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    required this.isVeg,
    this.isAvailable = true,
  });

  @override
  List<Object?> get props => [id, name, price, category, isVeg];
}

