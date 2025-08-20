import 'package:flutter/material.dart';

import '../../data/model/menu_item_model.dart';

class MenuItemWidget extends StatelessWidget {
  final MenuItemModel menuItem;
  final Function(int) onAddToCart;

  const MenuItemWidget({
    super.key,
    required this.menuItem,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            // Menu Item Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 80,
                height: 80,
                color: Colors.grey[300],
                child: menuItem.image.startsWith('http')
                    ? Image.network(
                  menuItem.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPlaceholderImage();
                  },
                )
                    : _buildPlaceholderImage(),
              ),
            ),

            SizedBox(width: 12),

            // Item Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Veg/Non-Veg Indicator
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          menuItem.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: menuItem.isVeg ? Colors.green : Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 6),

                  // Description
                  Text(
                    menuItem.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 8),

                  // Price and Add Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${menuItem.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),

                      ElevatedButton(
                        onPressed: menuItem.isAvailable
                            ? () => onAddToCart(1)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          minimumSize: Size(0, 32),
                        ),
                        child: Text(
                          menuItem.isAvailable ? 'Add' : 'Unavailable',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey[300],
      child: Icon(
        Icons.fastfood,
        color: Colors.grey,
        size: 40,
      ),
    );
  }
}
