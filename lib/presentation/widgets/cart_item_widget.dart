import 'package:flutter/material.dart';

import '../../data/model/cart_item_model.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemModel cartItem;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemWidget({
    super.key,
    required this.cartItem,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            // Menu Item Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 60,
                height: 60,
                color: Colors.grey[300],
                child: cartItem.menuItem.image.startsWith('http')
                    ? Image.network(
                  cartItem.menuItem.image,
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
                  Text(
                    cartItem.menuItem.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      if (cartItem.menuItem.isVeg)
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                      if (!cartItem.menuItem.isVeg)
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      SizedBox(width: 6),
                      Text(
                        cartItem.menuItem.isVeg ? 'Veg' : 'Non-Veg',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$${cartItem.menuItem.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),

            // Quantity Controls
            Column(
              children: [
                // Remove Button
                IconButton(
                  onPressed: onRemove,
                  icon: Icon(Icons.delete_outline),
                  color: Colors.red,
                  iconSize: 20,
                ),

                // Quantity Selector
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Decrease Button
                      InkWell(
                        onTap: () {
                          if (cartItem.quantity > 1) {
                            onQuantityChanged(cartItem.quantity - 1);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.remove,
                            size: 16,
                            color: cartItem.quantity > 1 ? Colors.red : Colors.grey,
                          ),
                        ),
                      ),

                      // Quantity Display
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Text(
                          '${cartItem.quantity}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),

                      // Increase Button
                      InkWell(
                        onTap: () {
                          onQuantityChanged(cartItem.quantity + 1);
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.add,
                            size: 16,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 8),

                // Total Price
                Text(
                  '\$${cartItem.totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
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
        size: 30,
      ),
    );
  }
}
